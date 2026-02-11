import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'notification.dart';

class NotificationDatasource implements INotificationDatasource {
  @override
  Future<String?> getToken() async {
    try {
      if (kIsWeb) {
        // Web requires a VAPID key from the Firebase Console
        return await FirebaseMessaging.instance.getToken(
          vapidKey: 'YOUR_PUBLIC_VAPID_KEY',
          //TODO fix
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
}
