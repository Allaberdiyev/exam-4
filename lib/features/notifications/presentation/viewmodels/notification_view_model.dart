import 'package:flutter/foundation.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../../../core/entities/notification.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _notificationRepository;
  List<Notification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  NotificationViewModel(this._notificationRepository);

  List<Notification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void listenToNotifications(String userId) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notificationRepository
          .getNotifications(userId)
          .listen(
            (notifications) {
              _notifications = notifications;
              _isLoading = false;
              notifyListeners();
            },
            onError: (e) {
              _error = e.toString();
              _isLoading = false;
              notifyListeners();
            },
          );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveNotification(Notification notification) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _notificationRepository.saveNotification(notification);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _notificationRepository.markNotificationAsRead(notificationId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _notificationRepository.deleteNotification(notificationId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
