import 'dart:async';

import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/socket/socket_service.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/chat/model/general_message_model.dart';
import 'package:hoodz/features/user/chat/model/order_support_chat_model.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/urls.dart';

class OrderSupportMessageController extends GetxController {
  OrderSupportMessageController(this._networkCaller);

  final NetworkCaller _networkCaller;
  late final SocketService socketService;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isInitialLoading = true.obs;
  final Rx<OrderSupportChatResponse?> _chatModel =
      Rx<OrderSupportChatResponse?>(null);
  final Rx<GeneralMessageModel?> _messageModel = Rx<GeneralMessageModel?>(null);
  final RxString chatId = ''.obs;
  final RxString orderId = ''.obs;
  final RxString chatTitle = 'Order Support'.obs;
  final RxString chatSubtitle = 'Online'.obs;
  final RxString receiverName = ''.obs;
  final RxString receiverAvatar = ''.obs;
  final RxList<Map<String, dynamic>> orderSupportMessages =
      <Map<String, dynamic>>[].obs;

  bool _hasInitialized = false;
  bool _isListeningSocket = false;

  OrderSupportChatResponse? get chatModel => _chatModel.value;
  GeneralMessageModel? get messageModel => _messageModel.value;
  List<Map<String, dynamic>> get messages => orderSupportMessages;
  String get apiPath => Urls.getChatMessagesUrlById(chatId.value);

  String get currentUserId {
    final storedUserId = MySharedPref.getUserId()?.trim() ?? '';
    if (storedUserId.isNotEmpty) {
      return storedUserId;
    }

    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();
      final profileUserId =
          profileController.userData?.id?.trim() ??
          profileController.userData?.dataId?.trim() ??
          '';
      if (profileUserId.isNotEmpty) {
        return profileUserId;
      }
    }

    return '';
  }

  @override
  void onInit() {
    super.onInit();
    socketService = Get.isRegistered<SocketService>()
        ? Get.find<SocketService>()
        : Get.put(SocketService());
    initialize(Get.arguments);
  }

  void initialize(Map<String, dynamic>? arguments) {
    if (_hasInitialized) {
      return;
    }
    _hasInitialized = true;

    chatId.value = arguments?['chatId']?.toString() ?? chatId.value;
    orderId.value = arguments?['orderId']?.toString() ?? orderId.value;
    chatTitle.value = arguments?['title']?.toString() ?? chatTitle.value;
    chatSubtitle.value =
        arguments?['subtitle']?.toString() ?? chatSubtitle.value;
    receiverName.value = arguments?['receiverName']?.toString() ?? '';
    receiverAvatar.value = arguments?['receiverAvatar']?.toString() ?? '';

    print(
      'ORDER SUPPORT SCREEN ENTER => storedUserId: ${MySharedPref.getUserId()} | resolvedCurrentUserId: $currentUserId | chatId: ${chatId.value} | orderId: ${orderId.value}',
    );

    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    try {
      await _ensureSocketReady();
      await _ensureCurrentUserIdLoaded();
      await _ensureOrderSupportChat();
      _listenSocketEvents();
      await getMessages();
    } finally {
      isInitialLoading.value = false;
    }
  }

  Future<void> _ensureSocketReady() async {
    if (!socketService.isInitialized) {
      final accessToken = MySharedPref.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        return;
      }

      await socketService.init();
    }
  }

  Future<void> _ensureCurrentUserIdLoaded() async {
    if (currentUserId.trim().isNotEmpty) {
      return;
    }

    if (!Get.isRegistered<ProfileController>()) {
      return;
    }

    final profileController = Get.find<ProfileController>();
    if (profileController.isLoading.value) {
      for (var i = 0; i < 20 && profileController.isLoading.value; i++) {
        await Future.delayed(const Duration(milliseconds: 150));
      }
    } else {
      await profileController.loadUserProfile(force: true);
    }

    final resolvedUserId =
        profileController.userData?.id?.trim() ??
        profileController.userData?.dataId?.trim() ??
        '';
    if (resolvedUserId.isNotEmpty) {
      await MySharedPref.setUserId(resolvedUserId);
    }
  }

  Future<void> _ensureOrderSupportChat() async {
    if (chatId.value.isNotEmpty) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return;
    }

    final resolvedOrderId = orderId.value.trim();
    if (resolvedOrderId.isEmpty) {
      showAppToast(
        message: 'Order support chat not available.',
        isError: true,
      );
      return;
    }

    try {
      final response = await _networkCaller.postRequest(
        Urls.chatUrl,
        accessToken: accessToken,
        body: {'type': 'order_support', 'order': resolvedOrderId},
      );

      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return;
      }

      if (response.responseData is! Map) {
        showAppToast(
          message: 'Order support chat response is invalid.',
          isError: true,
        );
        return;
      }

      final rawResponse = Map<String, dynamic>.from(response.responseData);
      final chatModel = OrderSupportChatResponse.fromJson(rawResponse);
      _chatModel.value = chatModel;

      final resolvedChatId =
          chatModel.data?.id?.trim() ??
          _extractChatId(rawResponse['data']) ??
          _extractChatId(rawResponse);

      if (resolvedChatId.isEmpty) {
        showAppToast(
          message: 'Order support chat not available.',
          isError: true,
        );
        return;
      }

      chatId.value = resolvedChatId;

      final participant = _extractSupportParticipant(chatModel.data);
      if (participant != null) {
        receiverName.value = participant.name?.toString() ?? receiverName.value;
        receiverAvatar.value =
            participant.profileAvatar?.toString() ?? receiverAvatar.value;
      }
    } catch (e) {
      showAppToast(
        message: 'Failed to load order support chat: $e',
        isError: true,
      );
    }
  }

  Future<void> getMessages() async {
    if (chatId.value.isEmpty || isLoading.value) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      showAppToast(
        message: 'Access token not found. Please login again.',
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _networkCaller.getRequest(
        apiPath,
        accessToken: accessToken,
      );

      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return;
      }

      final model = GeneralMessageModel.fromJson(
        Map<String, dynamic>.from(response.responseData),
      );
      _messageModel.value = model;

      final mappedMessages = model.data.map(_mapApiMessage).toList()
        ..sort(_compareMessagesByCreatedAt);
      orderSupportMessages
        ..clear()
        ..addAll(mappedMessages);
      orderSupportMessages.refresh();
    } catch (e) {
      showAppToast(message: 'Failed to load messages: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void sendMessage(String text, List<String> files) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty && files.isEmpty) {
      return;
    }

    if (chatId.value.isEmpty) {
      return;
    }

    if (!socketService.isInitialized) {
      return;
    }

    final payload = {
      'chatId': chatId.value,
      'text': trimmedText,
      'files': files,
      'senderId': currentUserId,
      'senderType': 'user',
    };

    print('ORDER SUPPORT SEND PAYLOAD => $payload');
    socketService.socket.emit('chat:send-message', payload);
  }

  void startTyping() {
    if (!socketService.isInitialized || chatId.value.isEmpty) {
      return;
    }

    socketService.socket.emit('chat:typing', {'chatId': chatId.value});
  }

  void stopTyping() {
    if (!socketService.isInitialized || chatId.value.isEmpty) {
      return;
    }

    socketService.socket.emit('chat:stop-typing', {'chatId': chatId.value});
  }

  void _listenSocketEvents() {
    if (_isListeningSocket || !socketService.isInitialized) {
      return;
    }

    _isListeningSocket = true;

    socketService.socket.on('chat:new-message', _handleIncomingMessage);
    socketService.socket.on('chat:message-updated', _handleMessageUpdated);
    socketService.socket.on('chat:message-deleted', _handleMessageDeleted);
    socketService.socket.on('chat:seen', _handleMessageSeen);
    socketService.socket.on('chat:typing', _handleTypingEvent);
    socketService.socket.on('chat:stop-typing', _handleTypingEvent);
  }

  void _handleIncomingMessage(dynamic data) {
    final message = _mapSocketMessage(data);
    if (!_belongsToCurrentChat(message)) {
      return;
    }

    _upsertMessage(message);
  }

  void _handleMessageUpdated(dynamic data) {
    final message = _mapSocketMessage(data);
    if (!_belongsToCurrentChat(message)) {
      return;
    }

    _upsertMessage(message);
  }

  void _handleMessageDeleted(dynamic data) {
    final payload = _extractPayload(data);
    final messageId = (payload['_id'] ?? payload['id'] ?? '').toString();
    if (messageId.isEmpty) {
      return;
    }

    final supportIndex = orderSupportMessages.indexWhere(
      (item) => item['id']?.toString() == messageId,
    );
    if (supportIndex == -1) {
      return;
    }

    orderSupportMessages.removeAt(supportIndex);
    orderSupportMessages.refresh();
  }

  void _handleMessageSeen(dynamic data) {
    final payload = _extractPayload(data);
    final messageId = (payload['messageId'] ?? payload['_id'] ?? '').toString();
    if (messageId.isEmpty) {
      return;
    }

    final index = orderSupportMessages.indexWhere(
      (item) => item['id']?.toString() == messageId,
    );
    if (index == -1) {
      return;
    }

    orderSupportMessages[index] = {
      ...orderSupportMessages[index],
      'seen': true,
    };
    orderSupportMessages.refresh();
  }

  void _handleTypingEvent(dynamic data) {
    // Typing state can be wired later if the UI needs it.
  }

  bool _belongsToCurrentChat(Map<String, dynamic> message) {
    final messageChatId = (message['chatId'] ?? message['chat'] ?? '')
        .toString()
        .trim();
    if (messageChatId.isEmpty) {
      return true;
    }
    return messageChatId == chatId.value.trim();
  }

  void _upsertMessage(Map<String, dynamic> message) {
    final messageId = message['id']?.toString().trim() ?? '';
    final index = messageId.isEmpty
        ? -1
        : orderSupportMessages.indexWhere(
            (item) => item['id']?.toString() == messageId,
          );

    if (index == -1) {
      orderSupportMessages.add(message);
    } else {
      orderSupportMessages[index] = {
        ...orderSupportMessages[index],
        ...message,
      };
    }

    orderSupportMessages.refresh();
  }

  OrderSupportChatUser? _extractSupportParticipant(
    OrderSupportChatData? chat,
  ) {
    if (chat == null || chat.participants.isEmpty) {
      return null;
    }

    for (final participant in chat.participants) {
      final user = participant.user;
      final role = (user?.role ?? '').toString().toLowerCase();
      if (role != 'user') {
        return user;
      }
    }

    return null;
  }

  Map<String, dynamic> _mapApiMessage(Datum message) {
    final senderId = _extractSenderId(message.sender);
    return {
      'id': message.id ?? '',
      'chatId': chatId.value,
      'text': message.text ?? '',
      'files': message.files,
      'seen': message.seen ?? false,
      'isEdited': message.isEdited ?? false,
      'sender': message.sender ?? '',
      'senderId': senderId,
      'senderType': message.senderType ?? '',
      'createdAt': message.createdAt?.toIso8601String() ?? '',
      'updatedAt': message.createdAt?.toIso8601String() ?? '',
    };
  }

  Map<String, dynamic> _mapSocketMessage(dynamic data) {
    final payload = _extractPayload(data);
    final sender = payload['sender'];
    final senderMap = sender is Map ? Map<String, dynamic>.from(sender) : null;

    return {
      'id': (payload['_id'] ?? payload['id'] ?? '').toString(),
      'chatId': (payload['chatId'] ?? payload['chat'] ?? chatId.value)
          .toString(),
      'text': (payload['text'] ?? payload['message'] ?? '').toString(),
      'files': payload['files'] ?? const [],
      'seen': payload['seen'] ?? false,
      'isEdited': payload['isEdited'] ?? false,
      'sender': senderMap ?? payload['sender'],
      'senderId':
          senderMap?['_id']?.toString() ??
          payload['senderId']?.toString() ??
          '',
      'senderType': (payload['senderType'] ?? '').toString(),
      'createdAt': (payload['createdAt'] ?? DateTime.now().toIso8601String())
          .toString(),
      'updatedAt': (payload['updatedAt'] ?? DateTime.now().toIso8601String())
          .toString(),
    };
  }

  Map<String, dynamic> _extractPayload(dynamic data) {
    if (data is Map) {
      final rawData = data['data'];
      if (rawData is Map) {
        return Map<String, dynamic>.from(rawData);
      }
      return Map<String, dynamic>.from(data);
    }

    return <String, dynamic>{};
  }

  String _extractChatId(dynamic data) {
    if (data is Map) {
      final value = data['_id'] ?? data['id'];
      if (value != null) {
        return value.toString().trim();
      }
    }
    return '';
  }

  bool isOwnMessage(Map<String, dynamic> message) {
    final senderId = _extractSenderId(message['senderId'] ?? message['sender']);
    final currentId = currentUserId.trim();

    print(
      'ORDER SUPPORT SIDE CHECK => senderId: $senderId | currentUserId: $currentId | messageId: ${message['id']} | text: ${message['text']}',
    );

    if (senderId.isEmpty || currentId.isEmpty) {
      return false;
    }

    return senderId == currentId;
  }

  String _extractSenderId(dynamic sender) {
    if (sender is Map) {
      return sender['_id']?.toString().trim() ?? '';
    }
    if (sender is String) {
      return sender.trim();
    }
    return '';
  }

  int _compareMessagesByCreatedAt(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final aTime = DateTime.tryParse(a['createdAt']?.toString() ?? '');
    final bTime = DateTime.tryParse(b['createdAt']?.toString() ?? '');

    if (aTime == null && bTime == null) {
      return 0;
    }
    if (aTime == null) {
      return -1;
    }
    if (bTime == null) {
      return 1;
    }

    return aTime.compareTo(bTime);
  }

  @override
  void onClose() {
    if (socketService.isInitialized) {
      socketService.socket.off('chat:new-message', _handleIncomingMessage);
      socketService.socket.off('chat:message-updated', _handleMessageUpdated);
      socketService.socket.off('chat:message-deleted', _handleMessageDeleted);
      socketService.socket.off('chat:seen', _handleMessageSeen);
      socketService.socket.off('chat:typing', _handleTypingEvent);
      socketService.socket.off('chat:stop-typing', _handleTypingEvent);
    }
    super.onClose();
  }
}
