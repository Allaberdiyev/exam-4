import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/location/presentation/screens/setup_location_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String setupLocation = '/setup-location';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      signup: (context) => const SignUpScreen(),
      home: (context) => const HomeScreen(),
      notifications: (context) => const NotificationsScreen(),
      settings: (context) => const SettingsScreen(),
      setupLocation: (context) => const SetupLocationScreen(),
    };
  }
}
