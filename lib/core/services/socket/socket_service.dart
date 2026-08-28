import 'package:get/get.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService extends GetxController {
  late io.Socket _socket;
  bool _isInitialized = false;

  final RxBool isConnected = false.obs;
  final RxList<Map<String, dynamic>> messageList = <Map<String, dynamic>>[].obs;

  bool get isInitialized => _isInitialized;
  io.Socket get socket => _socket;

  Future<SocketService> init() async {
    if (_isInitialized) {
      return this;
    }

    final token = MySharedPref.getAccessToken();
    if (token == null || token.isEmpty) {
      return this;
    }

    final userId = MySharedPref.getUserId();

    _socket = io.io(
      Urls.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .setAuth({'token': token})
          .enableAutoConnect()
          .setTimeout(10000)
          .build(),
    );

    _isInitialized = true;

    _socket.onConnect((_) {
      isConnected.value = true;
      if (userId != null && userId.isNotEmpty) {
        _socket.emit('connection', userId);
      }
    });

    _socket.onConnectError((err) {
      isConnected.value = false;
      print('Socket connect error: $err');
    });

    _socket.onError((err) {
      isConnected.value = false;
      print('Socket error: $err');
    });

    _socket.onDisconnect((_) {
      isConnected.value = false;
    });

    _socket.onReconnect((_) {
      isConnected.value = true;
      if (userId != null && userId.isNotEmpty) {
        _socket.emit('connection', userId);
      }
    });

    _socket.connect();
    return this;
  }

  void disconnect() {
    if (_isInitialized) {
      _socket.disconnect();
      _socket.clearListeners();
      _isInitialized = false;
    }
    isConnected.value = false;
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
