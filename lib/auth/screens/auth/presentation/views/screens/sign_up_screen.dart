import 'package:flutter/material.dart';
import 'package:imtihon4/auth/extensions/sized_box.dart';
import 'package:provider/provider.dart';
import '../../../data/datasources/auth_remote_datasources.dart';
import 'package:imtihon4/auth/routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String errorMessage = '';
  String selectedGender = 'male';
  DateTime? selectedBirthday;
  bool isLoading = false;

  void handleSignUp(BuildContext context) async {
    final email = loginController.text.trim();
    final password = passwordController.text;
    final rePassword = rePasswordController.text;
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    final authProvider = Provider.of<AuthRemoteDatasources>(
      context,
      listen: false,
    );

    if (email.isEmpty ||
        password.isEmpty ||
        rePassword.isEmpty ||
        name.isEmpty ||
        phone.isEmpty) {
      setState(() {
        errorMessage = "Iltimos, barcha maydonlarni to'ldiring.";
      });
      return;
    }

    if (password != rePassword) {
      setState(() {
        errorMessage = "Parollar mos emas.";
      });
      return;
    }

    if (selectedBirthday == null) {
      setState(() {
        errorMessage = "Iltimos, tug'ilgan kuningizni tanlang.";
      });
      return;
    }

    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    try {
      debugPrint('Starting sign up process...');

      // Create authentication account
      await authProvider.signUp(email, password);

      if (authProvider.user == null) {
        throw Exception('Failed to create user account');
      }

      debugPrint('Auth account created successfully, saving user data...');

      // Save user data to Realtime Database
      await authProvider.saveUserData(
        name: name,
        email: email,
        phoneNumber: phone,
        gender: selectedGender,
        birthday: selectedBirthday!,
      );

      debugPrint('User data saved successfully');

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ro'yxatdan o'tish muvaffaqiyatli!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, AuthRoutes.login);
      }
    } catch (e) {
      debugPrint('Error in handleSignUp: $e');
      if (mounted) {
        setState(() {
          errorMessage = "Xatolik yuz berdi: ${e.toString()}";
          isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedBirthday) {
      setState(() {
        selectedBirthday = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthRemoteDatasources>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: const Alignment(0, -0.5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                50.h,
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'To\'liq ismingiz',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                20.h,
                TextField(
                  controller: loginController,
                  decoration: InputDecoration(
                    hintText: 'Email yoki telefon raqamingizni kiriting',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                20.h,
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Telefon raqamingiz',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                20.h,
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
                20.h,
                TextField(
                  controller: rePasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Parolni qayta kiriting',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                20.h,
                Row(
                  children: [
                    const Text('Jinsingiz: '),
                    Radio<String>(
                      value: 'male',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    const Text('Erkak'),
                    Radio<String>(
                      value: 'female',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    const Text('Ayol'),
                  ],
                ),
                20.h,
                ListTile(
                  title: Text(
                    selectedBirthday == null
                        ? 'Tug\'ilgan kuningizni tanlang'
                        : 'Tug\'ilgan kun: ${selectedBirthday!.day}/${selectedBirthday!.month}/${selectedBirthday!.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                if (errorMessage.isNotEmpty) ...[
                  10.h,
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
                20.h,
                TextButton(
                  onPressed: isLoading ? null : () => handleSignUp(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(350, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Keyingisi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 3,
                            color: Colors.white,
                          ),
                        ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    overlayColor: Colors.transparent,
                    minimumSize: const Size(10, 20),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AuthRoutes.login);
                  },
                  child: const Align(
                    alignment: Alignment(1, 1),
                    child: Text(
                      'Ro\'yxatdan o\'tganmisiz?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: -1,
                      ),
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
