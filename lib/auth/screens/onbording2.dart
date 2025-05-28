
import 'package:flutter/material.dart';
import 'package:imtihon4/auth/extensions/app_colors.dart';
import 'package:imtihon4/auth/extensions/app_images.dart';
import 'package:imtihon4/auth/extensions/sized_box.dart';

class Onbording2 extends StatefulWidget {
  const Onbording2({super.key});

  @override
  State<Onbording2> createState() => _Onbording2State();
}

class _Onbording2State extends State<Onbording2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(AppImages.onbording2Image, width: 280),
          67.h,
          const Text(
            'Confirm Your Driver',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          33.h,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 36),
            child: const Text(
              textAlign: TextAlign.center,
              'Huge drivers network helps you find comforable, safe and cheap ride',
              style: TextStyle(
                color: AppColors.blackgrey,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
