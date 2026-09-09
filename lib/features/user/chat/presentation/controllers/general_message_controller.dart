import 'dart:async';

import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/socket/socket_service.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/chat/model/general_message_model.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:hoodz/urls.dart';

class GeneralMessageController extends GetxController { 
  GeneralMessageController(this._networkCaller);

  final NetworkCaller _networkCaller;
  late final SocketService socketService;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final Rx<GeneralMessageModel?> _messageModel = Rx<GeneralMessageModel?>(null);
  final RxString chatId = ''.obs;
  final RxString chatTitle = Strings.customerSupportChat.tr.obs;
  final RxString chatSubtitle = Strings.poweredByAI.tr.obs;
  final RxString receiverName = ''.obs;
  final RxString receiverAvatar = ''.obs;

  bool _hasInitialized = false;
  bool _isListeningSocket = false;

  GeneralMessageModel? get messageModel => _messageModel.value;
  RxList<Map<String, dynamic>> get socketMessages => socketService.messageList;
  List<Map<String, dynamic>> get messages => socketService.messageList;
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

    chatId.value = arguments?['chatId']?.toString() ?? '';
    chatTitle.value = arguments?['title']?.toString() ?? chatTitle.value;
    chatSubtitle.value =
        arguments?['subtitle']?.toString() ?? chatSubtitle.value;
    receiverName.value = arguments?['receiverName']?.toString() ?? '';
    receiverAvatar.value = arguments?['receiverAvatar']?.toString() ?? '';

    print(
      'GENERAL MESSAGE SCREEN ENTER => storedUserId: ${MySharedPref.getUserId()} | resolvedCurrentUserId: $currentUserId | chatId: ${chatId.value}',
    );

    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    if (chatId.value.isEmpty) {
      return;
    }

    await _ensureSocketReady();
    await _ensureCurrentUserIdLoaded();
    _listenSocketEvents();
    await getMessages();
  }

  Future<void> _ensureSocketReady() async {
    if (!socketService.isInitialized) {
      final accessToken = MySharedPref.getAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
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

  Future<void> getMessages() async {
    if (chatId.value.isEmpty || isLoading.value) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      showLoginRequiredDialog();
      return;
    }

    isLoading.value = true;

    try {
      final response = await _networkCaller.getRequest(
        apiPath,
        accessToken: accessToken,
      );

      if (isLoginRequiredResponse(response)) {
        showLoginRequiredDialog();
        return;
      }

      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return;
      }

      final model = GeneralMessageModel.fromJson(response.responseData);
      _messageModel.value = model;

      final mappedMessages = model.data.map(_mapApiMessage).toList()
        ..sort(_compareMessagesByCreatedAt);
      socketService.messageList
        ..clear()
        ..addAll(mappedMessages);
      socketService.messageList.refresh();
    } catch (e) {
      showAppToast(
        message: '${Strings.failedToLoadMessages.tr}$e',
        isError: true,
      );
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

    print('CHAT SEND PAYLOAD => $payload');
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

    final index = socketService.messageList.indexWhere(
      (item) => item['id']?.toString() == messageId,
    );
    if (index == -1) {
      return;
    }

    socketService.messageList.removeAt(index);
    socketService.messageList.refresh();
  }

  void _handleMessageSeen(dynamic data) {
    final payload = _extractPayload(data);
    final messageId = (payload['messageId'] ?? payload['_id'] ?? '').toString();
    if (messageId.isEmpty) {
      return;
    }

    final index = socketService.messageList.indexWhere(
      (item) => item['id']?.toString() == messageId,
    );
    if (index == -1) {
      return;
    }

    socketService.messageList[index] = {
      ...socketService.messageList[index],
      'seen': true,
    };
    socketService.messageList.refresh();
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
        : socketService.messageList.indexWhere(
            (item) => item['id']?.toString() == messageId,
          );

    if (index == -1) {
      socketService.messageList.add(message);
    } else {
      socketService.messageList[index] = {
        ...socketService.messageList[index],
        ...message,
      };
    }

    socketService.messageList.refresh();
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
      'chatId': _extractChatId(payload).isNotEmpty
          ? _extractChatId(payload)
          : chatId.value,
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
      for (final key in const ['data', 'payload', 'message']) {
        final rawData = data[key];
        if (rawData is Map) {
          return Map<String, dynamic>.from(rawData);
        }
      }
      return Map<String, dynamic>.from(data);
    }

    return <String, dynamic>{};
  }

  String _extractChatId(dynamic data) {
    if (data is! Map) {
      return '';
    }

    final direct = data['chatId'];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString().trim();
    }

    final chat = data['chat'];
    if (chat is Map) {
      final map = Map<String, dynamic>.from(chat);
      final id = map['_id'] ?? map['id'];
      return id?.toString().trim() ?? '';
    }

    return chat?.toString().trim() ?? '';
  }

  bool isOwnMessage(Map<String, dynamic> message) {
    final senderId = _extractSenderId(message['senderId'] ?? message['sender']);
    final currentId = currentUserId.trim();

    print(
      'CHAT SIDE CHECK => senderId: $senderId | currentUserId: $currentId | messageId: ${message['id']} | text: ${message['text']}',
    );

    if (senderId.isEmpty || currentId.isEmpty) {
      return false;
    }

    return senderId == currentId;
  }

  String _extractSenderId(dynamic sender) {
    if (sender is String) {
      return sender.trim();
    }

    if (sender is Map) {
      return (sender['_id'] ?? sender['id'] ?? sender['userId'] ?? '')
          .toString()
          .trim();
    }

    return sender?.toString().trim() ?? '';
  }

  int _compareMessagesByCreatedAt(
    Map<String, dynamic> first,
    Map<String, dynamic> second,
  ) {
    final firstTime = DateTime.tryParse(first['createdAt']?.toString() ?? '');
    final secondTime = DateTime.tryParse(second['createdAt']?.toString() ?? '');

    if (firstTime == null && secondTime == null) {
      return 0;
    }

    if (firstTime == null) {
      return 1;
    }

    if (secondTime == null) {
      return -1;
    }

    return firstTime.compareTo(secondTime);
  }

  @override
  void onClose() {
    if (socketService.isInitialized) {
      socketService.socket.off('chat:new-message');
      socketService.socket.off('chat:message-updated');
      socketService.socket.off('chat:message-deleted');
      socketService.socket.off('chat:seen');
      socketService.socket.off('chat:typing');
      socketService.socket.off('chat:stop-typing');
    }
    _isListeningSocket = false;
    super.onClose();
  }
}
