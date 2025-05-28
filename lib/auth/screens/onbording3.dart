import 'package:flutter/material.dart';
import 'package:imtihon4/auth/extensions/app_colors.dart';
import 'package:imtihon4/auth/extensions/app_images.dart';
import 'package:imtihon4/auth/extensions/sized_box.dart';
import 'package:imtihon4/auth/routes/app_routes.dart';

class Onbording3 extends StatefulWidget {
  const Onbording3({super.key});

  @override
  State<Onbording3> createState() => _Onbording3State();
}

class _Onbording3State extends State<Onbording3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(AppImages.onbording3Image, width: 280),
          67.h,
          const Text(
            textAlign: TextAlign.center,
            'Track your ride',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          33.h,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 41),
            child: const Text(
              textAlign: TextAlign.center,
              'Know your driver in advance and be able to view current location in real time on the map',
              style: TextStyle(color: Color(0xFF6C6C6C), fontSize: 15),
            ),
          ),

          56.h,
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AuthRoutes.setupLocation);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(190, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: AppColors.green,
            ),
            child: const Text(
              "Get Started",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
