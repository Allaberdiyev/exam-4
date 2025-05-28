import '../../../../core/entities/notification.dart';

abstract class NotificationRepository {
  Future<void> saveNotification(Notification notification);
  Stream<List<Notification>> getNotifications(String userId);
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
}
