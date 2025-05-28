import 'package:flutter/material.dart';
import 'package:imtihon4/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_models/chat_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String rideId;
  final String userId;
  final String driverId;

  const ChatScreen({
    Key? key,
    required this.rideId,
    required this.userId,
    required this.driverId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Color get mintGreen => const Color(0xFF6EE7B7);
  Color get lightGray => const Color(0xFFF6F7FB);
  Color get sendGreen => const Color(0xFF6EE7B7);

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTimestamp(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final isToday =
        now.year == time.year && now.month == time.month && now.day == time.day;
    final timeString = DateFormat('h:mm a').format(time);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Center(
        child: Text(
          isToday
              ? 'Today at $timeString'
              : DateFormat('MMM d, h:mm a').format(time),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildBubble({
    required String text,
    required bool isMe,
    required bool showTail,
  }) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe && showTail)
          CustomPaint(
            painter: BubbleTailPainter(isMe: false, color: lightGray),
            size: Size(12.w, 16.h),
          ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
              left: isMe ? 40.w : 8.w,
              right: isMe ? 8.w : 40.w,
              top: 2.h,
              bottom: 2.h,
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isMe ? mintGreen : lightGray,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(isMe ? 16.r : 4.r),
                bottomRight: Radius.circular(isMe ? 4.r : 16.r),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        if (isMe && showTail)
          CustomPaint(
            painter: BubbleTailPainter(isMe: true, color: mintGreen),
            size: Size(12.w, 16.h),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(
        rideId: widget.rideId,
        userId: widget.userId,
        driverId: widget.driverId,
      ),
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150.h),
              child: Container(
                color: mintGreen,
                padding: EdgeInsets.fromLTRB(0, 44.h, 0, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) {
                        return SettingsScreen(userId: 'user1');
                      })),
                    ),
                    if (viewModel.driverInfo != null)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                viewModel.driverInfo!['name'] ?? 'Driver',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            CircleAvatar(
                              radius: 40.r,
                              backgroundImage: NetworkImage(
                                viewModel.driverInfo!['image'] ?? '',
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8.h,
                      ),
                      itemCount: viewModel.messages.length,
                      itemBuilder: (context, index) {
                        final message = viewModel.messages[index];
                        final isMe = message['senderId'] == widget.userId;
                        final showTail =
                            (index == viewModel.messages.length - 1) ||
                                (viewModel.messages[index + 1]['senderId'] !=
                                    message['senderId']);
                        // Show timestamp if first message or if previous message is from different sender
                        final showTimestamp = index == 0 ||
                            DateFormat('dMy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    viewModel.messages[index - 1]['timestamp'],
                                  ),
                                ) !=
                                DateFormat('dMy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    message['timestamp'],
                                  ),
                                ) ||
                            (viewModel.messages[index - 1]['senderId'] !=
                                message['senderId']);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (showTimestamp)
                              _buildTimestamp(message['timestamp']),
                            _buildBubble(
                              text: message['text'],
                              isMe: isMe,
                              showTail: showTail,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    color: lightGray,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(color: mintGreen, fontSize: 16.sp),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: mintGreen.withOpacity(0.7),
                                fontSize: 16.sp,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: BorderSide(
                                  color: mintGreen,
                                  width: 1.5.w,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: BorderSide(
                                  color: mintGreen,
                                  width: 2.w,
                                ),
                              ),
                            ),
                            onSubmitted: (text) {
                              if (text.trim().isNotEmpty) {
                                viewModel.sendMessage(text);
                                _messageController.clear();
                                _scrollToBottom();
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            if (_messageController.text.trim().isNotEmpty) {
                              viewModel.sendMessage(_messageController.text);
                              _messageController.clear();
                              _scrollToBottom();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: mintGreen, width: 2.w),
                            ),
                            padding: EdgeInsets.all(8.w),
                            child: Icon(
                              Icons.send,
                              color: sendGreen,
                              size: 28.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class BubbleTailPainter extends CustomPainter {
  final bool isMe;
  final Color color;
  BubbleTailPainter({required this.isMe, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (isMe) {
      path.moveTo(0, 0);
      path.lineTo(12, 8);
      path.lineTo(0, 16);
      path.close();
      canvas.drawPath(path, paint);
    } else {
      path.moveTo(12, 0);
      path.lineTo(0, 8);
      path.lineTo(12, 16);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
