import 'package:flutter/material.dart';
import 'package:imtihon4/auth/extensions/app_colors.dart';
import 'package:imtihon4/auth/extensions/app_images.dart';
import 'package:imtihon4/auth/extensions/sized_box.dart';
import 'package:imtihon4/auth/routes/app_routes.dart';


class SetupGpsLocations extends StatefulWidget {
  const SetupGpsLocations({super.key});

  @override
  State<SetupGpsLocations> createState() => _SetupGpsLocationsState();
}

class _SetupGpsLocationsState extends State<SetupGpsLocations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Image.asset(AppImages.setupGPSLocations, height: 250),
          ),
          Column(
            children: [
              const Text(
                "Hi, nice to meet you!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              17.h,
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Choose your location to start find restaurants around you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.blackgrey),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AuthRoutes.login);
                  },
                  icon: Transform.rotate(
                    angle: 0.8,
                    child: const Icon(
                      Icons.navigation,
                      color: AppColors.green,
                      size: 25,
                    ),
                  ),
                  label: const Text(
                    "Use current location",
                    style: TextStyle(color: AppColors.green, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: AppColors.green),
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ),
              40.h,
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AuthRoutes.login);
                },
                child: const Text(
                  "Select it manually",
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
