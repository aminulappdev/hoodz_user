import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hoodz/core/utils/share_preference.dart';

import '../../../firebase_options.dart';

class PushNotificationService {
  PushNotificationService._internal();

  static final PushNotificationService _instance =
      PushNotificationService._internal();

  factory PushNotificationService() => _instance;

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'Used for important push notifications';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init({void Function(String? route)? onNotificationTap}) async {
    if (_isInitialized) {
      return;
    }

    await _initializeLocalNotifications(onNotificationTap);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification == null) {
        return;
      }

      await _showNotification(
        title: notification.title,
        body: notification.body,
        payload: _extractRoute(message),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onNotificationTap?.call(_extractRoute(message));
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      onNotificationTap?.call(_extractRoute(initialMessage));
    }

    _messaging.onTokenRefresh.listen((token) async {
      if (token.trim().isNotEmpty) {
        await MySharedPref.setFcmToken(token);
      }
    });

    _isInitialized = true;
  }

  Future<String?> getOrCreateToken() async {
    final savedToken = MySharedPref.getFcmToken();
    if (savedToken != null && savedToken.trim().isNotEmpty) {
      return savedToken;
    }

    try {
      await _requestPermission();
    } catch (error) {
      debugPrint('Push notification permission request failed: $error');
      return null;
    }

    final token = await _waitForToken();
    if (token != null && token.trim().isNotEmpty) {
      await MySharedPref.setFcmToken(token);
    }
    return token;
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (Platform.isIOS || Platform.isMacOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<String?> _waitForToken() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final apnsToken = await _waitForApnsToken();
      if (apnsToken == null || apnsToken.trim().isEmpty) {
        return null;
      }
    }

    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final token = await _messaging.getToken();
        if (token != null && token.trim().isNotEmpty) {
          return token;
        }
      } catch (error) {
        debugPrint(
          'FCM token fetch failed on attempt ${attempt + 1}: $error',
        );
      }

      await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
    }

    return null;
  }

  Future<String?> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 6; attempt++) {
      try {
        final token = await _messaging.getAPNSToken();
        if (token != null && token.trim().isNotEmpty) {
          return token;
        }
      } catch (error) {
        debugPrint('APNs token fetch failed on attempt ${attempt + 1}: $error');
      }

      await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
    }

    return null;
  }

  Future<void> _initializeLocalNotifications(
    void Function(String? route)? onNotificationTap,
  ) async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        onNotificationTap?.call(response.payload);
      },
    );

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    final androidPlugin = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(androidChannel);
  }

  Future<void> _showNotification({
    required String? title,
    required String? body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title ?? 'Notification',
      body ?? '',
      notificationDetails,
      payload: payload,
    );
  }

  String? _extractRoute(RemoteMessage message) {
    final route = message.data['route'];
    if (route is String && route.trim().isNotEmpty) {
      return route;
    }
    return null;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const channelId = 'high_importance_channel';
  const channelName = 'High Importance Notifications';
  const channelDescription = 'Used for important push notifications';

  const androidDetails = AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.high,
    priority: Priority.high,
  );

  const iosDetails = DarwinNotificationDetails();
  const notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? 'Notification',
    message.notification?.body ?? '',
    notificationDetails,
    payload: message.data['route']?.toString(),
  );
}
