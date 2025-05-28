import 'package:flutter/material.dart';
import 'package:imtihon4/auth/screens/auth/presentation/views/screens/login_in_screen.dart';
import 'package:imtihon4/auth/screens/auth/presentation/views/screens/sign_up_screen.dart';
import 'package:imtihon4/auth/screens/onbording1.dart';
import 'package:imtihon4/auth/screens/setup_GPS_locations.dart';
import 'package:imtihon4/auth/screens/splash_screen.dart';

import 'package:imtihon4/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:imtihon4/features/settings/presentation/screens/settings_screen.dart';
import 'package:imtihon4/screens/chat_screen.dart';
import 'package:imtihon4/screens/invite_friends_contacts_screen.dart';
import 'package:imtihon4/screens/my_account_screen.dart';
import 'package:imtihon4/screens/my_wallet_screen.dart';
import 'package:imtihon4/screens/payment_method_screen.dart';
import 'package:imtihon4/screens/rating_screen.dart';
import 'package:imtihon4/screens/tip_screen.dart';

class AuthRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String setupLocation = '/setup-location';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String chat = '/chat';
  static const String dashboard = '/dashboard';
  static const String inviteFriends = '/invite-friends';
  static const String myAccount = '/my-account';
  static const String myWallet = '/my-wallet';
  static const String notifications = '/notifications';
  static const String paymentMethod = '/payment-method';
  static const String rating = '/rating';
  static const String settings = '/settings';
  static const String tip = '/tip';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const Onbording1(),
        setupLocation: (context) => const SetupGpsLocations(),
        login: (context) => const LoginInScreen(),
        signUp: (context) => const SignUpScreen(),
        chat: (context) => const ChatScreen(
              rideId: "ride123",
              userId: 'user1',
              driverId: 'driver7',
            ),
        inviteFriends: (context) => const InviteFriendsContactsScreen(),
        myAccount: (context) => const MyAccountScreen(
              userId: 'user1',
            ),
        myWallet: (context) => const MyWalletScreen(),
        notifications: (context) => const NotificationsScreen(),
        paymentMethod: (context) => const PaymentMethodScreen(),
        rating: (context) => const RatingScreen(
              rideId: "ride123",
              driverName: 'jose',
              driverImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDclwWbnmT8PqVRnc6zhm--1VgNPrdUmX4fw&s',
              driverCar: 'Lada',
            ),
        settings: (context) => const SettingsScreen(),
        tip: (context) => const TipScreen(
              rideId: "ride123",
              driverName: 'jose',
              driverImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDclwWbnmT8PqVRnc6zhm--1VgNPrdUmX4fw&s',
              driverCar: 'Lada',
              rating: 3,
            ),
      };
}
