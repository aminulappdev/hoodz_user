import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/services/others/show_loader.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/chat/presentation/pages/customer_support_message_screen.dart';
import 'package:hoodz/features/user/chat/presentation/pages/general_message_screen.dart';
import 'package:hoodz/features/user/chat/presentation/pages/order_support_message_screen.dart';
import 'package:hoodz/urls.dart';

class ChatSystemController extends GetxController {
  ChatSystemController(this._networkCaller);

  final NetworkCaller _networkCaller;
  final RxBool isCreatingChat = false.obs;

  Future<Map<String, dynamic>?> createCustomerSupportChat() async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      print('CUSTOM SUPPORT CREATE ERROR => Access token not found.');
      return null;
    }

    Map<String, dynamic>? createdChat;

    await showLoadingOverLay(
      msg: 'Opening customer support...',
      asyncFunction: () async {
        isCreatingChat.value = true;

        try {
          final response = await _networkCaller.postRequest(
            Urls.chatUrl,
            accessToken: accessToken,
            body: {'type': 'customer_support'},
          );

          print(
            'CUSTOM SUPPORT CREATE STATUS CODE => ${response.statusCode}',
          );
          print('CUSTOM SUPPORT CREATE SUCCESS => ${response.isSuccess}');
          print('CUSTOM SUPPORT CREATE MESSAGE => ${response.message}');
          print('CUSTOM SUPPORT CREATE RAW RESPONSE => ${response.responseData}');

          if (!response.isSuccess) {
            print('CUSTOM SUPPORT CREATE ERROR => ${response.errorMessage}');
            return;
          }

          final chatData = _extractChatData(response.responseData);
          if (chatData == null) {
            print('CUSTOM SUPPORT CREATE ERROR => Could not parse chat data.');
            return;
          }

          _printChatData(chatData);
          createdChat = chatData;
        } finally {
          isCreatingChat.value = false;
        }
      },
    );

    final createdChatData = createdChat;
    if (createdChatData != null) {
      final chatArgs = _buildChatArguments(createdChatData);
      Get.to(() => const CustomerSupportMessageScreen(), arguments: chatArgs);
    }

    return createdChat;
  }

  Future<Map<String, dynamic>?> createOrderSupportChat({
    required String orderId,
  }) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      print('ORDER SUPPORT CREATE ERROR => Access token not found.');
      return null;
    }

    if (orderId.trim().isEmpty) {
      print('ORDER SUPPORT CREATE ERROR => orderId is empty.');
      return null;
    }

    Map<String, dynamic>? createdChat;

    await showLoadingOverLay(
      msg: 'Opening order support...',
      asyncFunction: () async {
        isCreatingChat.value = true;

        try {
          final response = await _networkCaller.postRequest(
            Urls.chatUrl,
            accessToken: accessToken,
            body: {'type': 'order_support', 'order': orderId.trim()},
          );

          print(
            'ORDER SUPPORT CREATE STATUS CODE => ${response.statusCode}',
          );
          print('ORDER SUPPORT CREATE SUCCESS => ${response.isSuccess}');
          print('ORDER SUPPORT CREATE MESSAGE => ${response.message}');
          print(
            'ORDER SUPPORT CREATE RAW RESPONSE => ${response.responseData}',
          );

          if (!response.isSuccess) {
            print('ORDER SUPPORT CREATE ERROR => ${response.errorMessage}');
            return;
          }

          final chatData = _extractChatData(response.responseData);
          if (chatData == null) {
            print('ORDER SUPPORT CREATE ERROR => Could not parse chat data.');
            return;
          }

          _printChatData(chatData);
          createdChat = chatData;
        } finally {
          isCreatingChat.value = false;
        }
      },
    );

    final createdChatData = createdChat;
    if (createdChatData != null) {
      final chatArgs = _buildChatArguments(createdChatData);
      chatArgs['title'] = 'Order Support';
      chatArgs['subtitle'] = 'Online';
      chatArgs['orderId'] = orderId.trim();
      Get.to(() => const OrderSupportMessageScreen(), arguments: chatArgs);
    }

    return createdChat;
  }

  Future<Map<String, dynamic>?> createSingleChat({
    required String participantId,
  }) async {
    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      print('CHAT CREATE ERROR => Access token not found.');
      return null;
    }

    if (participantId.trim().isEmpty) {
      print('CHAT CREATE ERROR => participantId is empty.');
      return null;
    }

    Map<String, dynamic>? createdChat;

    await showLoadingOverLay(
      msg: 'Creating chat...',
      asyncFunction: () async {
        isCreatingChat.value = true;

        try {
          final response = await _networkCaller.postRequest(
            Urls.chatUrl,
            accessToken: accessToken,
            body: {'type': 'single_chat', 'participent': participantId},
          );

          print('CHAT CREATE STATUS CODE => ${response.statusCode}');
          print('CHAT CREATE SUCCESS => ${response.isSuccess}');
          print('CHAT CREATE MESSAGE => ${response.message}');
          print('CHAT CREATE RAW RESPONSE => ${response.responseData}');

          if (!response.isSuccess) {
            print('CHAT CREATE ERROR => ${response.errorMessage}');
            return;
          }

          final chatData = _extractChatData(response.responseData);
          if (chatData == null) {
            print('CHAT CREATE ERROR => Could not parse chat data.');
            return;
          }

          _printChatData(chatData);
          createdChat = chatData;
        } finally {
          isCreatingChat.value = false;
        }
      },
    );

    final createdChatData = createdChat;
    if (createdChatData != null) {
      final chatArgs = _buildChatArguments(createdChatData);
      Get.to(() => const GeneralMessageScreen(), arguments: chatArgs);
    }

    return createdChat;
  }

  Map<String, dynamic>? _extractChatData(dynamic responseData) {
    if (responseData is! Map) {
      return null;
    }

    final data = responseData['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return null;
  }

  void _printChatData(Map<String, dynamic> chatData) {
    final chatId = chatData['_id']?.toString() ?? '';
    final chatType = chatData['type']?.toString() ?? '';
    final chatStatus = chatData['status']?.toString() ?? '';
    final createdAt = chatData['createdAt']?.toString() ?? '';
    final updatedAt = chatData['updatedAt']?.toString() ?? '';
    final order = chatData['order'];
    final participants = chatData['participants'];

    print('----- CHAT CREATED SUCCESSFULLY -----');
    print('CHAT ID => $chatId');
    print('CHAT TYPE => $chatType');
    print('CHAT STATUS => $chatStatus');
    print('CHAT CREATED AT => $createdAt');
    print('CHAT UPDATED AT => $updatedAt');
    print('CHAT ORDER => ${order ?? 'null'}');

    if (participants is List) {
      for (final participant in participants) {
        if (participant is! Map) {
          continue;
        }

        final participantId = participant['_id']?.toString() ?? '';
        final participantChatId = participant['chat']?.toString() ?? '';
        final user = participant['user'];
        final userId = user is Map ? (user['_id']?.toString() ?? '') : '';
        final userName = user is Map ? (user['name']?.toString() ?? '') : '';
        final userAvatar = user is Map
            ? (user['profileAvatar']?.toString() ?? '')
            : '';
        final userRole = user is Map ? (user['role']?.toString() ?? '') : '';

        print('PARTICIPANT ROW =>');
        print('  PARTICIPANT ID => $participantId');
        print('  PARTICIPANT CHAT ID => $participantChatId');
        print('  USER ID => $userId');
        print('  USER NAME => $userName');
        print('  USER AVATAR => $userAvatar');
        print('  USER ROLE => $userRole');
      }
    }
  }

  Map<String, dynamic> _buildChatArguments(Map<String, dynamic> chatData) {
    final participants = chatData['participants'];
    Map<String, dynamic>? otherParticipant;

    if (participants is List) {
      for (final participant in participants) {
        if (participant is! Map) {
          continue;
        }

        final user = participant['user'];
        if (user is! Map) {
          continue;
        }

        final role = (user['role'] ?? '').toString().toLowerCase();
        if (role != 'user') {
          otherParticipant = Map<String, dynamic>.from(user);
          break;
        }
      }
    }

    otherParticipant ??= {};

    return {
      'chatId': chatData['_id']?.toString() ?? '',
      'title': otherParticipant['name']?.toString() ?? 'Chat',
      'subtitle': otherParticipant['role']?.toString() ?? 'Powered by AI',
      'receiverName': otherParticipant['name']?.toString() ?? '',
      'receiverAvatar': otherParticipant['profileAvatar']?.toString() ?? '',
      'chatData': chatData,
    };
  }
}
