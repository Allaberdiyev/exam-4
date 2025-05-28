import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class ChatViewModel extends ChangeNotifier {
  final DatabaseReference _chatRef = FirebaseDatabase.instance.ref();
  final String rideId;
  final String userId;
  final String driverId;
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  String? lastRespondedMessageId;
  Map<String, dynamic>? driverInfo;

  ChatViewModel({
    required this.rideId,
    required this.userId,
    required this.driverId,
  }) {
    _listenToMessages();
    _fetchDriverInfo();
  }

  Future<void> _fetchDriverInfo() async {
    final driverSnapshot =
        await _chatRef.child('exam').child('drivers').child(driverId).get();

    if (driverSnapshot.value != null) {
      driverInfo = Map<String, dynamic>.from(
        (driverSnapshot.value as Map<dynamic, dynamic>).cast<String, dynamic>(),
      );
      notifyListeners();
    }
  }

  void _listenToMessages() {
    _chatRef
        .child('exam')
        .child('rides')
        .child(rideId)
        .child('chat')
        .onValue
        .listen((event) {
          if (event.snapshot.value != null) {
            final data = Map<String, dynamic>.from(
              (event.snapshot.value as Map<dynamic, dynamic>)
                  .cast<String, dynamic>(),
            );
            messages = data.entries.map((entry) {
                    return <String, dynamic>{'id': entry.key, ...entry.value};
                  }).toList()
                  ..sort(
                    (a, b) => (a['timestamp'] as int).compareTo(
                      b['timestamp'] as int,
                    ),
                  );

            notifyListeners();
            _checkForNewUserMessages();
          }
        });
  }

  void _checkForNewUserMessages() {
    if (messages.isEmpty) return;

    final lastMessage = messages.last;
    if (lastMessage['senderId'] == userId &&
        lastMessage['id'] != lastRespondedMessageId &&
        lastMessage['senderId'] != driverId) {
      lastRespondedMessageId = lastMessage['id'];
      _sendAutomatedDriverResponse(lastMessage['text']);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessageRef =
        _chatRef
            .child('exam')
            .child('rides')
            .child(rideId)
            .child('chat')
            .push();

    await newMessageRef.set({
      'senderId': userId,
      'text': text.trim(),
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> _sendAutomatedDriverResponse(String userMessage) async {

    await Future.delayed(const Duration(seconds: 5));

    String response = _generateDriverResponse(userMessage);

    final newMessageRef =
        _chatRef
            .child('exam')
            .child('rides')
            .child(rideId)
            .child('chat')
            .push();

    await newMessageRef.set({
      'senderId': driverId,
      'text': response,
      'timestamp': ServerValue.timestamp,
    });
  }

  String _generateDriverResponse(String userMessage) {

    final message = userMessage.toLowerCase();


    final responses = {
      'hi': [
        'Hi! How are you doing today?',
        'Hello! How can I help you?',
        'Hi there! How\'s your day going?',
      ],
      'where': [
        'I\'m about 5 minutes away, stuck in traffic.',
        'I\'m nearby, just 5 minutes away. There\'s some traffic though.',
        'I\'m 5 minutes away, but there\'s heavy traffic on the way.',
      ],
      'how long': [
        'About 5 minutes, but there\'s some traffic ahead.',
        'I\'ll be there in 5 minutes, though traffic is a bit heavy.',
        'Just 5 minutes away, but the traffic is slowing us down.',
      ],
      'wait': [
        'I\'m on my way, just 5 minutes away.',
        'Almost there, just 5 minutes more.',
        'Just 5 minutes away, please wait a bit longer.',
      ],
      'traffic': [
        'Yes, there\'s heavy traffic ahead. I\'ll be there in 5 minutes.',
        'The traffic is quite bad, but I\'ll be there in 5 minutes.',
        'Traffic is heavy, but I\'m just 5 minutes away.',
      ],
      'late': [
        'I apologize for the delay. I\'m just 5 minutes away.',
        'Sorry for being late. I\'ll be there in 5 minutes.',
        'I\'m running a bit late, but just 5 minutes away.',
      ],
      'cancel': [
        'I understand. I\'ll cancel the ride. Have a great day!',
        'No problem, I\'ll cancel the ride. Take care!',
        'I\'ll cancel the ride. Sorry for any inconvenience.',
      ],
      'thanks': [
        'You\'re welcome! Have a great ride!',
        'No problem at all! Enjoy your trip!',
        'My pleasure! Have a safe journey!',
      ],
      'help': [
        'I\'m here to help! What do you need?',
        'How can I assist you?',
        'I\'m at your service. What can I do for you?',
      ],
      'default': [
        'I\'m on my way, just 5 minutes away.',
        'I\'ll be there shortly, about 5 minutes.',
        'Just 5 minutes away, please wait.',
      ],
    };


    for (var keyword in responses.keys) {
      if (message.contains(keyword)) {
        final possibleResponses = responses[keyword]!;
        return possibleResponses[DateTime.now().millisecondsSinceEpoch %
            possibleResponses.length];
      }
    }

    final defaultResponses = responses['default']!;
    return defaultResponses[DateTime.now().millisecondsSinceEpoch %
        defaultResponses.length];
  }
}
