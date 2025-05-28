import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class MyAccountScreen extends StatefulWidget {
  final String userId;
  const MyAccountScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
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

  Future<void> _editField(
    String key,
    String label,
    String? initialValue, {
    bool isDate = false,
  }) async {
    TextEditingController controller = TextEditingController(
      text: initialValue,
    );
    DateTime? selectedDate;
    if (isDate && initialValue != null) {
      try {
        selectedDate = DateFormat('MMMM d,yyyy').parse(initialValue);
      } catch (_) {}
    }
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit $label'),
            content:
                isDate
                    ? InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime(1990, 1, 1),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          controller.text = DateFormat(
                            'MMMM d,yyyy',
                          ).format(picked);
                        }
                      },
                      child: IgnorePointer(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Select date',
                          ),
                        ),
                      ),
                    )
                    : TextField(
                      controller: controller,
                      decoration: InputDecoration(hintText: 'Enter $label'),
                    ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final value = controller.text.trim();
                  if (value.isNotEmpty) {
                    await FirebaseDatabase.instance
                        .ref('exam/users/${widget.userId}/$key')
                        .set(value);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Widget _fieldRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(label, style: const TextStyle(fontSize: 16)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
        onTap: onTap,
        minVerticalPadding: 0,
        dense: true,
      ),
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
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 48, top: 24),
                    child: const Text(
                      'My Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  if (userData?['image'] != null)
                    Positioned(
                      right: 16,
                      top: 24,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userData!['image']),
                        radius: 24,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child:
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(height: 8),
                          _fieldRow(
                            label: 'Level',
                            value: userData?['level'] ?? '',
                            onTap:
                                () => _editField(
                                  'level',
                                  'Level',
                                  userData?['level'],
                                ),
                          ),
                          const Divider(height: 1),
                          _fieldRow(
                            label: 'Name',
                            value: userData?['name'] ?? '',
                            onTap:
                                () => _editField(
                                  'name',
                                  'Name',
                                  userData?['name'],
                                ),
                          ),
                          const Divider(height: 1),
                          _fieldRow(
                            label: 'Email',
                            value: userData?['email'] ?? '',
                            onTap:
                                () => _editField(
                                  'email',
                                  'Email',
                                  userData?['email'],
                                ),
                          ),
                          const Divider(height: 1),
                          _fieldRow(
                            label: 'Gender',
                            value: userData?['gender'] ?? '',
                            onTap:
                                () => _editField(
                                  'gender',
                                  'Gender',
                                  userData?['gender'],
                                ),
                          ),
                          const Divider(height: 1),
                          _fieldRow(
                            label: 'Birthday',
                            value: userData?['birthday'] ?? '',
                            onTap:
                                () => _editField(
                                  'birthday',
                                  'Birthday',
                                  userData?['birthday'],
                                  isDate: true,
                                ),
                          ),
                          const Divider(height: 1),
                          _fieldRow(
                            label: 'Phone number',
                            value: userData?['phoneNumber'] ?? '',
                            onTap:
                                () => _editField(
                                  'phoneNumber',
                                  'Phone number',
                                  userData?['phoneNumber'],
                                ),
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
