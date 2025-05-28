import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;
  const NotificationsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late DatabaseReference _notificationsRef;
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _notificationsRef = FirebaseDatabase.instance.ref(
      'exam/users/${widget.userId}/notifications',
    );
    _fetchNotifications();
  }

  void _fetchNotifications() {
    _notificationsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final notifs =
            data.entries.map((e) {
              final value = Map<String, dynamic>.from(e.value);
              value['id'] = e.key;
              return value;
            }).toList();
        notifs.sort(
          (a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0),
        );
        setState(() {
          _notifications = notifs;
          _loading = false;
        });
      } else {
        setState(() {
          _notifications = [];
          _loading = false;
        });
      }
    });
  }

  void _deleteAll() async {
    await _notificationsRef.remove();
  }

  Widget _buildIcon(Map<String, dynamic> notif) {
    final title = (notif['title'] ?? '').toString().toLowerCase();
    if (title.contains('promotion')) {
      return CircleAvatar(
        backgroundColor: Colors.green[50],
        child: Icon(Icons.card_giftcard, color: Colors.green, size: 28),
        radius: 24,
      );
    } else if (title.contains('cancel')) {
      return CircleAvatar(
        backgroundColor: Colors.red[50],
        child: Icon(Icons.cancel, color: Colors.red, size: 28),
        radius: 24,
      );
    } else if (title.contains('booking') || title.contains('success')) {
      return CircleAvatar(
        backgroundColor: Colors.blue[50],
        child: Icon(Icons.check_circle, color: Colors.blue, size: 28),
        radius: 24,
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(Icons.notifications, color: Colors.black54, size: 28),
        radius: 24,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6EE7B7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6EE7B7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _notifications.isEmpty ? null : _deleteAll,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _notifications.isEmpty
                ? const Center(child: Text('No notifications'))
                : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: _notifications.length,
                  separatorBuilder:
                      (_, __) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, i) {
                    final notif = _notifications[i];
                    return ListTile(
                      leading: _buildIcon(notif),
                      title: Text(
                        notif['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        notif['body'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {},
                    );
                  },
                ),
      ),
    );
  }
}
