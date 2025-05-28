import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetupLocationScreen extends StatefulWidget {
  const SetupLocationScreen({super.key});

  @override
  State<SetupLocationScreen> createState() => _SetupLocationScreenState();
}

class _SetupLocationScreenState extends State<SetupLocationScreen> {
  bool _locationEnabled = false;
  bool _backgroundLocationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Services',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            SwitchListTile(
              title: const Text('Enable Location'),
              subtitle: const Text('Allow app to access your location'),
              value: _locationEnabled,
              onChanged: (value) {
                setState(() {
                  _locationEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Background Location'),
              subtitle: const Text('Allow location access when app is in background'),
              value: _backgroundLocationEnabled,
              onChanged: (value) {
                setState(() {
                  _backgroundLocationEnabled = value;
                });
              },
            ),
            SizedBox(height: 20.h),
            Text(
              'Location Accuracy',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('High Accuracy'),
                    SizedBox(height: 8.h),
                    const Text(
                      'Uses GPS, Wi-Fi, and mobile networks to determine location',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement location accuracy settings
                      },
                      child: const Text('Change Accuracy'),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save location settings
                  Navigator.pop(context);
                },
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 