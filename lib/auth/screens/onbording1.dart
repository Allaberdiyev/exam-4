import 'package:flutter/material.dart';
import 'package:imtihon4/auth/extensions/app_colors.dart';
import 'package:imtihon4/auth/extensions/app_images.dart';
import 'package:imtihon4/auth/extensions/sized_box.dart';
import 'package:imtihon4/auth/routes/app_routes.dart';
import 'package:imtihon4/auth/screens/onbording2.dart';
import 'package:imtihon4/auth/screens/onbording3.dart';

class Onbording1 extends StatefulWidget {
  const Onbording1({super.key});

  @override
  State<Onbording1> createState() => _Onbording1State();
}

class _Onbording1State extends State<Onbording1> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: [_buildPage1(), const Onbording2(), const Onbording3()],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color:
                      currentPage == index ? AppColors.green : AppColors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
          20.h,
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppImages.onbording1Image, width: 280),
        67.h,

        Text(
          'Request Ride',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        33.h,

        Container(
          margin: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'Request a ride get picked up by a nearby community driver',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
