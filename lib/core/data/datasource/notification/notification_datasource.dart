import 'package:celta_inventario/core/data/datasource/notification/notification.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationDatasource implements INotificationDatasource {
  @override
  Stream<String> get onTokenRefresh {
    if (PlatformUtil.isDesktop || PlatformUtil.isWeb) {
      return const Stream.empty();
    }

    return FirebaseMessaging.instance.onTokenRefresh;
  }

  @override
  Future<String?> getToken() async {
    try {
      if (PlatformUtil.isDesktop || PlatformUtil.isWeb) {
        // Web requires a VAPID key from the Firebase Console
        return null;
      }

      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('Notifications: FCM Token retrieved: $token');
      return token;
    } catch (e) {
      debugPrint('Notifications Error: Failed to get FCM token - $e');
      return null;
    }
  }
}
