import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/notifications/presentation/state/notification_provider.dart';
import '../di/di_config.dart';
import '../platform/string_constants.dart';

final _logger = Logger();

/// Top-level handler — must be a top-level function for background messages.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) _logger.i('Background message received: ${message.messageId}');
}

class FirebaseCloudMessagingManager {
  static final FirebaseCloudMessagingManager instance =
      FirebaseCloudMessagingManager._internal();

  factory FirebaseCloudMessagingManager() => instance;

  FirebaseCloudMessagingManager._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool _initialized = false;

  /// Request permission, obtain the FCM token, and configure message handlers.
  /// Call this after the user has logged in.
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final settings = await _requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        if (kDebugMode) _logger.w('User declined push notification permission');
        return;
      }

      // Set foreground notification presentation options (iOS).
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _initToken();
      _listenToTokenRefresh();
      _configureForegroundHandler();

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      _initialized = true;
      if (kDebugMode) _logger.i('FCM initialized successfully');
    } catch (e, s) {
      if (kDebugMode) _logger.e('Error initialising FCM: $e\n$s');
    }
  }

  /// Request notification permission (required on iOS, Android 13+).
  Future<NotificationSettings> _requestPermission() async {
    return await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
  }

  /// Get the current FCM token and send it to the server.
  Future<void> _initToken() async {
    // getToken() works on both physical devices and simulators.
    // On iOS it internally waits for the APNs token.
    String? token = await _fcm.getToken();

    if (token == null) {
      if (kDebugMode) _logger.w('FCM token is null');
      return;
    }

    if (kDebugMode) _logger.i('FCM token: $token');

    final prefs = inject<SharedPreferences>();
    final existingToken = prefs.getString(SPref.FCM_TOKEN);

    // Only register if the token is new or changed.
    if (existingToken != token) {
      await prefs.setString(SPref.FCM_TOKEN, token);
      await _sendTokenToServer(token);
    }
  }

  /// Listen for token rotations from the OS and re-register.
  void _listenToTokenRefresh() {
    _fcm.onTokenRefresh.listen((newToken) async {
      final prefs = inject<SharedPreferences>();
      await prefs.setString(SPref.FCM_TOKEN, newToken);
      await _sendTokenToServer(newToken);
    });
  }

  /// Handle messages received while the app is in the foreground.
  void _configureForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        _logger.i('Foreground message: ${message.notification?.title}');
      }

      final notification = message.notification;
      if (notification != null) {
        showSimpleNotification(
          Text(notification.title ?? ''),
          subtitle: Text(notification.body ?? ''),
          background: const Color(0xFF215543),
          foreground: const Color(0xFFFFFFFF),
          duration: const Duration(seconds: 4),
        );
      }

      // Refresh the notification list so the badge count updates.
      try {
        inject<NotificationProvider>().fetchNotifications(limit: 20);
      } catch (_) {}
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        _logger.i('Notification tapped: ${message.notification?.title}');
      }
      // Refresh notifications when user taps a notification to open the app.
      try {
        inject<NotificationProvider>().fetchNotifications(limit: 20);
      } catch (_) {}
    });
  }

  /// Send the FCM token to the backend via the notification provider.
  Future<void> _sendTokenToServer(String token) async {
    try {
      final provider = inject<NotificationProvider>();
      await provider.registerPushToken(fcmToken: token);
      if (kDebugMode) _logger.i('FCM token registered with server');
    } catch (e) {
      if (kDebugMode) _logger.e('Failed to send FCM token to server: $e');
    }
  }
}
