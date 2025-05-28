import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/screens/invite_friends_card_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_models/tip_view_model.dart';

class TipScreen extends StatefulWidget {
  final String rideId;
  final String driverName;
  final String driverImage;
  final String driverCar;
  final double rating;

  const TipScreen({
    super.key,
    required this.rideId,
    required this.driverName,
    required this.driverImage,
    required this.driverCar,
    required this.rating,
  });

  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  double selectedTip = 2.0;
  final currencyFormat = NumberFormat.simpleCurrency(decimalDigits: 0);

  Future<void> _showCustomAmountDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter custom tip'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Enter amount',
              prefixText: '4',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null && value > 0) {
                  Navigator.pop(context, value);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() => selectedTip = result);
    }
  }

  String getTipMessage() {
    if (widget.rating >= 4.5) {
      return "Wow! A 5 star! Wanna add tip for ${widget.driverName}?";
    } else if (widget.rating >= 4.0) {
      return "Not bad! Wanna give a tip for ${widget.driverName}?";
    } else if (widget.rating >= 3.0) {
      return "Thanks for your feedback! Would you like to leave a tip?";
    } else {
      return "Thank you for your feedback.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final mintGreen = const Color(0xFF6EE7B7);
    final blue = const Color(0xFF3B5BFE);

    return ChangeNotifierProvider(
      create: (_) => TipViewModel(rideId: widget.rideId),
      child: Consumer<TipViewModel>(
        builder: (context, tipVM, child) {
          return Scaffold(
            backgroundColor: mintGreen,
            appBar: AppBar(
              backgroundColor: mintGreen,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: Text(
                'Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40.r,
                      backgroundImage: NetworkImage(widget.driverImage),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      widget.driverName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.driverCar,
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      getTipMessage(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [1, 2, 5].map((amount) {
                        final isSelected = selectedTip == amount.toDouble();
                        return GestureDetector(
                          onTap: () => setState(
                            () => selectedTip = amount.toDouble(),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? blue : const Color(0xFFF6F7FB),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                currencyFormat.format(amount),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: _showCustomAmountDialog,
                      child: Text(
                        'Choose other amount',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: tipVM.isLoading
                          ? null
                          : () async {
                              await tipVM.setTip(selectedTip);
                              if (context.mounted)
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (ctx) {
                                  return InviteFriendsCardScreen(
                                      inviteCode: "123helloj");
                                }));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        minimumSize: Size(double.infinity, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: tipVM.isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.w,
                              ),
                            )
                          : Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Maybe next time',
                      style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
