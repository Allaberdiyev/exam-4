import 'package:flutter/material.dart';
import 'package:imtihon4/auth/extensions/app_colors.dart';
import 'package:imtihon4/auth/extensions/app_images.dart';
import 'package:imtihon4/auth/extensions/sized_box.dart';
import 'package:imtihon4/auth/routes/app_routes.dart';
import 'package:imtihon4/auth/screens/auth/data/datasources/auth_remote_datasources.dart';
import 'package:imtihon4/auth/screens/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:imtihon4/auth/screens/auth/presentation/views/screens/login_in_screen.dart';
import 'package:imtihon4/auth/screens/auth/presentation/views/screens/sign_up_screen.dart';
import 'package:imtihon4/auth/screens/splash_screen.dart';
import 'package:imtihon4/screens/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});

  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthViewmodel authViewModel = AuthViewmodel();
  final AuthRemoteDatasources userAuthController = AuthRemoteDatasources();

  String errorMessage = '';
  bool isLoading = false;

  Future<void> handleLogin() async {
    final email = loginController.text.trim();
    final password = passwordController.text;

    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    await userAuthController.signIn(email, password);

    if (userAuthController.user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);

      if (mounted) {
        Navigator.pushReplacementNamed(context, AuthRoutes.splash);
      }
    } else {
      setState(() {
        errorMessage = userAuthController.error ?? 'Login amalga oshmadi';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: const Alignment(0, -0.2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: loginController,
                  decoration: InputDecoration(
                    hintText: 'Email yoki login kiriting',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Parolni kiriting',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AuthRoutes.signUp);
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Ro\'yxatdan o\'tmaganmisiz?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return MapWithSearchScreen();
                    }));
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Kirish',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
