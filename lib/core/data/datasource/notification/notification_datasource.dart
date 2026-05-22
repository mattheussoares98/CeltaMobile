import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:celta_inventario/core/data/datasource/notification/notification.dart';

class NotificationDatasource implements INotificationDatasource {
  @override
  Future<String?> getToken() async {
    try {
      if (kIsWeb) {
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
