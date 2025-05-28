import 'package:flutter/material.dart';
import 'package:imtihon4/screens/my_wallet_screen.dart';

class InviteFriendsContactsScreen extends StatefulWidget {
  const InviteFriendsContactsScreen({Key? key}) : super(key: key);

  @override
  State<InviteFriendsContactsScreen> createState() =>
      _InviteFriendsContactsScreenState();
}

class _InviteFriendsContactsScreenState
    extends State<InviteFriendsContactsScreen> {
  final List<Map<String, dynamic>> _contacts = [
    {'name': 'Johnny Rios', 'avatar': null, 'selected': true},
    {'name': 'Alfred Hodges', 'avatar': null, 'selected': false},
    {'name': 'Samuel Hammond', 'avatar': null, 'selected': true},
    {'name': 'Dora Hines', 'avatar': null, 'selected': false},
    {'name': 'Carolyn Francis', 'avatar': null, 'selected': false},
    {'name': 'Isaiah McGee', 'avatar': null, 'selected': false},
    {'name': 'Mark Holmes', 'avatar': null, 'selected': true},
    {'name': 'Russell McGuire', 'avatar': null, 'selected': false},
  ];
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _contacts
        .where(
          (c) => c['name'].toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6EE7B7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return MyWalletScreen();
          })),
        ),
        title: const Text(
          'Invite Friends',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF6EE7B7),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, i) {
                final c = filtered[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Text(c['name'][0]),
                  ),
                  title: Text(c['name']),
                  trailing: c['selected']
                      ? const Icon(
                          Icons.check_box,
                          color: Color(0xFF6EE7B7),
                        )
                      : const Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.grey,
                        ),
                  onTap: () => setState(() => c['selected'] = !c['selected']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
