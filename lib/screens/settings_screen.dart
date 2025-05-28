import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:imtihon4/auth/screens/splash_screen.dart';
import 'package:imtihon4/screens/rating_screen.dart';
import 'package:imtihon4/screens/tip_screen.dart';
import 'notifications_screen.dart';
import 'my_account_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String userId;
  const SettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.ref('exam/users/${widget.userId}').onValue.listen(
      (event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            userData = Map<String, dynamic>.from(data);
            _loading = false;
          });
        } else {
          setState(() {
            userData = null;
            _loading = false;
          });
        }
      },
    );
  }

  Widget _profileRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: userData?['image'] != null
                ? NetworkImage(userData!['image'])
                : null,
            radius: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData?['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userData?['level'] ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }

  Widget _sectionTile({required String title, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      onTap: onTap,
      minVerticalPadding: 0,
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: const Color(0xFF6EE7B7),
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0,
                bottom: 20,
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) {
                        return RatingScreen(
                            rideId: 'ride123',
                            driverName: 'robert ',
                            driverImage:
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUqjfsCy2_j8wscjeUqQalfld9JIBNha42dw&s',
                            driverCar: 'bmw');
                      })),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 48, top: 24),
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return MyAccountScreen(
                                  userId: 'user1',
                                );
                              }));
                            },
                            child: _profileRow()),
                        const Divider(height: 1),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return NotificationsScreen(userId: 'user1');
                            }));
                          },
                          child: _sectionTile(
                            title: 'Notifications',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotificationsScreen(
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        _sectionTile(title: 'Security', onTap: () {}),
                        _sectionTile(title: 'Language', onTap: () {}),
                        const Divider(height: 24),
                        _sectionTile(title: 'Clear cache', onTap: () {}),
                        _sectionTile(
                          title: 'Terms & Privacy Policy',
                          onTap: () {},
                        ),
                        _sectionTile(title: 'Contact us', onTap: () {}),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextButton(
                              onPressed: null,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: Colors.grey,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                disabledForegroundColor: Colors.grey,
                                disabledBackgroundColor: Colors.grey[100],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const SplashScreen()),
                                    (route) =>
                                        false, // Remove all previous routes
                                  );
                                },
                                child: const Text("Log Out"),
                              )),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
