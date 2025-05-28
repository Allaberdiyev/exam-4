import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/notification_view_model.dart';
import '../../../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../../../core/entities/notification.dart' as app;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    final authViewModel = context.read<AuthViewModel>();
    final notificationViewModel = context.read<NotificationViewModel>();
    final currentUser = authViewModel.currentUser;

    if (currentUser != null) {
      notificationViewModel.listenToNotifications(currentUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationViewModel = context.watch<NotificationViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body:
          notificationViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : notificationViewModel.error != null
              ? Center(
                child: Text(
                  notificationViewModel.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : notificationViewModel.notifications.isEmpty
              ? const Center(child: Text('No notifications yet'))
              : ListView.builder(
                itemCount: notificationViewModel.notifications.length,
                itemBuilder: (context, index) {
                  final notification =
                      notificationViewModel.notifications[index];
                  return _NotificationTile(
                    notification: notification,
                    onMarkAsRead: () {
                      notificationViewModel.markNotificationAsRead(
                        notification.id,
                      );
                    },
                    onDelete: () {
                      notificationViewModel.deleteNotification(notification.id);
                    },
                  );
                },
              ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final app.Notification notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(notification.body),
        trailing:
            notification.isRead
                ? null
                : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: onMarkAsRead,
                ),
      ),
    );
  }
}
