import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../view_models/rating_view_model.dart';
import 'tip_screen.dart';

class RatingScreen extends StatefulWidget {
  final String rideId;
  final String driverName;
  final String driverImage;
  final String driverCar;

  const RatingScreen({
    super.key,
    required this.rideId,
    required this.driverName,
    required this.driverImage,
    required this.driverCar,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 4.0;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mintGreen = const Color(0xFF6EE7B7);
    final blue = const Color(0xFF3B5BFE);

    return ChangeNotifierProvider(
      create: (_) => RatingViewModel(rideId: widget.rideId),
      child: Consumer<RatingViewModel>(
        builder: (context, ratingVM, child) {
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
                'Rating',
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
                      'How is your trip?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your feedback will help improve driving experience',
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final filled = rating >= index + 1;
                        return IconButton(
                          onPressed: () => setState(() => rating = index + 1.0),
                          icon: Icon(
                            filled
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: filled ? Colors.amber : Colors.grey[300],
                            size: 36.sp,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16.h),
                    TextField(
                      controller: commentController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Additional comments...',
                        filled: true,
                        fillColor: const Color(0xFFF6F7FB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed:
                          ratingVM.isLoading
                              ? null
                              : () async {
                                  await ratingVM.setRating(
                                    rating,
                                    commentController.text,
                                  );
                                  if (context.mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => TipScreen(
                                          rideId: widget.rideId,
                                          driverName: widget.driverName,
                                          driverImage: widget.driverImage,
                                          driverCar: widget.driverCar,
                                          rating: rating,
                                        ),
                                      ),
                                    );
                                  }
                                },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        minimumSize: Size(double.infinity, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child:
                          ratingVM.isLoading
                              ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.w,
                                ),
                              )
                              : Text(
                                'Submit Review',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
