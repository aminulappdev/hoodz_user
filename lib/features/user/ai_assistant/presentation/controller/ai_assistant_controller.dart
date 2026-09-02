import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/socket/socket_service.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/urls.dart';

class AiAssistantController extends GetxController {
  AiAssistantController(this._networkCaller);

  final NetworkCaller _networkCaller;
  late final SocketService socketService;

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isTyping = false.obs;
  final RxString chatId = ''.obs;

  bool _isListening = false;
  int _localMessageCounter = 0;

  @override
  void onInit() {
    super.onInit();
    socketService = Get.isRegistered<SocketService>()
        ? Get.find<SocketService>()
        : Get.put(SocketService());
    final arguments = Get.arguments is Map
        ? Map<String, dynamic>.from(Get.arguments as Map)
        : <String, dynamic>{};
    chatId.value = arguments['chatId']?.toString() ?? '';
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    await _ensureSocketReady();
    _listenSocketEvents();
    await loadMessages();
  }

  Future<void> _ensureSocketReady() async {
    if (socketService.isInitialized) return;
    final token = MySharedPref.getAccessToken();
    if (token != null && token.isNotEmpty) await socketService.init();
  }

  Future<void> loadMessages() async {
    if (isLoading.value) return;
    final token = MySharedPref.getAccessToken();
    if (token == null || token.isEmpty) {
      showAppToast(
        message: Strings.accessTokenNotFoundPleaseLoginAgain.tr,
        isError: true,
      );
      return;
    }
    isLoading.value = true;
    try {
      final response = await _networkCaller.getRequest(
        Urls.aiAssistantMessagesUrl,
        accessToken: token,
      );
      if (!response.isSuccess) {
        showAppToast(message: response.errorMessage, isError: true);
        return;
      }
      _updateChatIdFromHistory(response.responseData);
      final list = _findList(response.responseData);
      messages
        ..clear()
        ..addAll(list.map(_mapMessage));
      messages.sort(_compareMessages);
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
    final value = text.trim();
    if (isSending.value || (value.isEmpty && files.isEmpty)) return;
    if (!socketService.isInitialized) {
      showAppToast(message: Strings.failedToLoadMessages.tr, isError: true);
      return;
    }

    isSending.value = true;
    messages.add({
      'id': 'local-ai-${_localMessageCounter++}',
      'chatId': chatId.value,
      'text': value,
      'files': files,
      'isMe': true,
      'createdAt': DateTime.now().toIso8601String(),
      'products': const <Map<String, dynamic>>[],
    });
    unawaited(_emitAiMessage({
      'message': value,
      if (files.isNotEmpty) 'files': files,
    }));
    Future<void>.delayed(const Duration(seconds: 15), () {
      if (isSending.value) isSending.value = false;
    });
  }

  Future<void> _emitAiMessage(Map<String, dynamic> payload) async {
    debugPrint('AI emit ai:send-message payload => $payload');
    try {
      final ack = await socketService.socket.emitWithAckAsync(
        'ai:send-message',
        payload,
      );
      debugPrint('AI emit ai:send-message ack => $ack');
      final ackPayload = _payload(ack);
      if (ackPayload.isNotEmpty) {
        final incomingChatId = _chatIdFromPayload(ackPayload);
        if (incomingChatId.isNotEmpty) chatId.value = incomingChatId;
      }
    } catch (error) {
      debugPrint('AI emit ai:send-message ack failed => $error');
      socketService.socket.emit('ai:send-message', payload);
      debugPrint('AI emit ai:send-message sent without ack');
    }
  }

  void _listenSocketEvents() {
    if (_isListening || !socketService.isInitialized) return;
    _isListening = true;
    socketService.socket.on('ai:message', _handleAiMessage);
    socketService.socket.on('chat:new-message', _handleChatMessage);
  }

  void _handleAiMessage(dynamic data) {
    debugPrint('AI socket ai:message received => $data');
    final payload = _payload(data);
    final incomingChatId = _chatIdFromPayload(payload);
    if (incomingChatId.isNotEmpty) chatId.value = incomingChatId;
    final message = _mapMessage(payload, forceAssistant: true);
    if (message['text'].toString().isNotEmpty ||
        (message['products'] as List).isNotEmpty) {
      _upsert(message);
    }
    isTyping.value = false;
    isSending.value = false;
  }

  void _handleChatMessage(dynamic data) {
    debugPrint('AI socket chat:new-message received => $data');
    final payload = _payload(data);
    final incomingChatId = _chatIdFromPayload(payload);
    final senderType = (payload['senderType'] ?? payload['type'] ?? '')
        .toString()
        .toLowerCase();
    if (chatId.value.isEmpty && incomingChatId.isEmpty &&
        !{'ai', 'assistant', 'bot', 'user'}.contains(senderType)) return;
    if (chatId.value.isNotEmpty && incomingChatId.isNotEmpty &&
        incomingChatId != chatId.value) return;
    if (incomingChatId.isNotEmpty) chatId.value = incomingChatId;

    final message = _mapMessage(payload);
    _replacePendingOrUpsert(message);
    if (message['isMe'] == true) isSending.value = false;
  }

  Map<String, dynamic> _mapMessage(dynamic data, {bool forceAssistant = false}) {
    final payload = data is Map<String, dynamic> ? data : _payload(data);
    final senderType = (payload['senderType'] ?? payload['type'] ?? '')
        .toString()
        .toLowerCase();
    final isMe = !forceAssistant &&
        (senderType == 'user' || senderType == 'customer' ||
            payload['isMe'] == true);
    return {
      'id': (payload['_id'] ?? payload['id'] ?? '').toString(),
      'chatId': _chatIdFromPayload(payload).isNotEmpty
          ? _chatIdFromPayload(payload)
          : chatId.value,
      'text':
          (payload['text'] ?? payload['message'] ?? payload['response'] ?? '')
              .toString(),
      'files': _stringList(payload['files']),
      'isMe': isMe,
      'createdAt':
          (payload['createdAt'] ?? DateTime.now().toIso8601String())
              .toString(),
      'products': _productList(payload),
    };
  }

  void _replacePendingOrUpsert(Map<String, dynamic> message) {
    final index = messages.indexWhere((item) {
      return item['id'].toString().startsWith('local-ai-') &&
          item['isMe'] == true && item['text'] == message['text'];
    });
    if (index >= 0) {
      messages[index] = message;
    } else {
      _upsert(message);
    }
    messages.sort(_compareMessages);
  }

  void _upsert(Map<String, dynamic> message) {
    final id = message['id'].toString();
    final index = id.isEmpty
        ? -1
        : messages.indexWhere((item) => item['id'].toString() == id);
    if (index < 0) {
      messages.add(message);
    } else {
      messages[index] = {...messages[index], ...message};
    }
    messages.sort(_compareMessages);
  }

  Map<String, dynamic> _payload(dynamic data) {
    if (data is Map) {
      final nested = data['data'];
      if (nested is Map) return Map<String, dynamic>.from(nested);
      return Map<String, dynamic>.from(data);
    }
    return <String, dynamic>{};
  }

  List<dynamic> _findList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['messages', 'results']) {
        if (data[key] is List) return List<dynamic>.from(data[key] as List);
      }
      if (data['data'] != null) return _findList(data['data']);
    }
    return const [];
  }

  List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }

  List<Map<String, dynamic>> _productList(Map<String, dynamic> payload) {
    final metadata = payload['metadata'];
    final metadataProducts = metadata is Map ? metadata['products'] : null;
    final raw = payload['products'] ??
        payload['recommendations'] ??
        payload['productRecommendations'] ??
        metadataProducts;
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  void _updateChatIdFromHistory(dynamic data) {
    if (data is! Map) return;
    final root = Map<String, dynamic>.from(data);
    final nested = root['data'];
    if (nested is! Map) return;
    final payload = Map<String, dynamic>.from(nested);
    final incomingChatId = _chatIdFromPayload(payload);
    if (incomingChatId.isNotEmpty) chatId.value = incomingChatId;
  }

  String _chatIdFromPayload(Map<String, dynamic> payload) {
    final direct = payload['chatId'];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString();
    }

    final chat = payload['chat'];
    if (chat is Map) {
      final map = Map<String, dynamic>.from(chat);
      final id = map['_id'] ?? map['id'];
      return id?.toString() ?? '';
    }

    return chat?.toString() ?? '';
  }

  int _compareMessages(Map<String, dynamic> a, Map<String, dynamic> b) {
    final first = DateTime.tryParse(a['createdAt'].toString());
    final second = DateTime.tryParse(b['createdAt'].toString());
    if (first == null || second == null) return 0;
    return first.compareTo(second);
  }

  @override
  void onClose() {
    if (_isListening && socketService.isInitialized) {
      socketService.socket.off('ai:message', _handleAiMessage);
      socketService.socket.off('chat:new-message', _handleChatMessage);
    }
    super.onClose();
  }
}
