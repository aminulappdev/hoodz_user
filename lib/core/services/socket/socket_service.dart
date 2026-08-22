// // ignore_for_file: library_prefixes, avoid_print
// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:wisper/app/core/others/get_storage.dart';
// import 'package:wisper/app/urls.dart';

// class SocketService extends GetxController {
//   late IO.Socket _socket;

//   // Observable variables 
//   RxBool isLoading = false.obs;
//   RxBool isConnected = false.obs; // Tracks connection status

//   final _messageList = <Map<String, dynamic>>[].obs;
//   final _socketFriendList = <Map<String, dynamic>>[].obs; 
//   final _notificationsList = <Map<String, dynamic>>[].obs;

//   // Getters
//   RxList<Map<String, dynamic>> get messageList => _messageList;
//   RxList<Map<String, dynamic>> get socketFriendList => _socketFriendList;
//   RxList<Map<String, dynamic>> get notificationsList => _notificationsList;
//   IO.Socket get socket => _socket;

//   /// Initialize the socket connection
//   Future<SocketService> init() async {
//     print('🔌 Initializing socket service. Connecting...');

//     final token = StorageUtil.getData(StorageUtil.userAccessToken);
//     final userId = StorageUtil.getData(StorageUtil.userId);

//     print('Token: $token');
//     print('User ID: $userId');

//     if (token == null || userId == null) {
//       print('🔴 Token or User ID is missing!');
//       return this;
//     }

//     // Create Socket.IO connection using modern OptionBuilder
//     _socket = IO.io(
//       Urls.socketUrl,
//       IO.OptionBuilder()
//           .setTransports([
//             'websocket',
//           ]) // Force websocket transport (recommended for Flutter)
//           .setExtraHeaders({
//             'Authorization': 'Bearer $token',
//           }) // Send token in headers
//           .enableAutoConnect() // Enable automatic connection
//           .setTimeout(10000) // 10 seconds connection timeout
//           .build(),
//     );

//     // ✅ Successful connection
//     _socket.onConnect((_) {
//       print('✅ Successfully connected to the server!');
//       isConnected.value = true;
//       _socket.emit("connection", userId); // Send user ID to server
//     });

//     // 🔴 Connection error (most important for debugging)
//     _socket.onConnectError((err) {
//       print('🔴 Connection error: $err');
//       isConnected.value = false;
//     });

//     // 🔴 General socket error
//     _socket.onError((err) {
//       print('🔴 Socket error: $err');
//       isConnected.value = false;
//     });

//     // 🔴 Disconnected from server
//     _socket.onDisconnect((_) {
//       print('🔴 Socket disconnected');
//       isConnected.value = false;
//     });

//     // 🟢 Reconnection successful
//     _socket.onReconnect((attempt) {
//       print('🟢 Reconnected successfully! Attempt: $attempt');
//       isConnected.value = true;
//       _socket.emit("connection", userId);
//     });

//     // 🔔 Custom event: notification check
//     _socket.on('checking_notification', (data) {
//       print('🔔 Notification data received:');
//       print(data);
//       // Add to list if needed
//       // _notificationsList.add(data as Map<String, dynamic>);
//     });

//     // Manually trigger connection
//     _socket.connect();

//     return this;
//   }

//   /// Manually disconnect the socket
//   void disconnect() {
//     if (_socket.connected || isConnected.value) {
//       _socket.disconnect();
//       print('🔌 Socket manually disconnected');
//     }
//     _socket.clearListeners(); // Clear all listeners
//     isConnected.value = false;
//   }

//   /// Cleanup when controller is removed
//   @override
//   void onClose() {
//     disconnect();
//     super.onClose();
//   }
// }
