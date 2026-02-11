import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../firebase_options.dart';

/// PERFORMANCE: Using a dedicated service for notifications ensures
/// that Firebase listeners are registered exactly once and do not
/// create memory leaks during hot restarts.
class NotificationsService {
  NotificationsService._();
  static final instance = NotificationsService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// PERFORMANCE: This must be a top-level or static function.
  /// It runs in a completely separate isolate when the app is backgrounded.
  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    // We must re-initialize Firebase in the background isolate.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint(
      'Notifications: Background message received: ${message.messageId}',
    );
  }

  /// Sets up the notification channels and listeners.
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Request permissions (especially important for iOS and Android 13+)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Setup Background Handler
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    // 3. Setup Foreground Listeners
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // 4. Setup Interaction Listeners (Terminated & Background)
    _setupInteractions();

    // 5. Initialize Local Notifications for Android "Heads-up"
    if (!kIsWeb) {
      await _setupLocalNotifications();
    }
    await Future.delayed(const Duration(seconds: 3));
    await getFcmToken();

    _isInitialized = true;
  }

  /// PERFORMANCE: Retrieves the FCM token for session synchronization.
  /// This works on Android, iOS, and Web.
  Future<String?> getFcmToken() async {
    try {
      if (kIsWeb) {
        // Web requires a VAPID key from the Firebase Console
        return await FirebaseMessaging.instance.getToken(
          vapidKey: 'YOUR_PUBLIC_VAPID_KEY',
        );
      }

      // On iOS/macOS, we can check APNS status, but getToken()
      // generally handles the mapping internally for FCM.
      final String? token;
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        token = await FirebaseMessaging.instance.getAPNSToken();
        debugPrint('Notifications: APNs Token retrieved: $token');
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }
      debugPrint('Notifications: FCM Token retrieved: $token');
      return token;
    } catch (e) {
      debugPrint('Notifications Error: Failed to get FCM token - $e');
      return null;
    }
  }

  Future<void> _setupLocalNotifications() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Celta Mobile Notifications',
      description: 'Used for important system alerts.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/notification'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification click here
      },
    );
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Celta Mobile Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }

  void _setupInteractions() {
    // Terminated State
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint(
          'Notifications: App opened from terminated state via: ${message.messageId}',
        );
      }
    });

    // Background State
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint(
        'Notifications: App opened from background via: ${message.messageId}',
      );
    });
  }
}
