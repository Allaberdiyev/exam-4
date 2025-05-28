import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> saveNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      // Extract userId from data if available
      final String? userId = message.data['userId'];
      if (userId == null) {
        debugPrint('No userId found in notification data');
        return;
      }

      final notificationData = {
        'title': notification.title,
        'body': notification.body,
        'timestamp': ServerValue.timestamp,
        'rideId': message.data['rideId'], // Include rideId if available
      };

      // Save to user's notifications node
      await _db
          .child('exam')
          .child('users')
          .child(userId)
          .child('notifications')
          .push()
          .set(notificationData);

      debugPrint('Notification saved successfully for user: $userId');
    } catch (e) {
      debugPrint('Error saving notification: $e');
    }
  }
}
 