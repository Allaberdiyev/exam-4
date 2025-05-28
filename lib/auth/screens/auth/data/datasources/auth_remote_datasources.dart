import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthRemoteDatasources extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  User? user;
  String? error;
  bool isLoading = false;

  AuthRemoteDatasources() {
    _auth.authStateChanges().listen((user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      debugPrint('Starting sign up process for email: $email');

      // Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the current user after creation
      user = _auth.currentUser;

      if (user == null) {
        throw Exception('Failed to create user account');
      }

      debugPrint('User created successfully with UID: ${user?.uid}');
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      error = e.message;
      notifyListeners();
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during sign up: $e');
      error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = _auth.currentUser;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      error = e.message;
      notifyListeners();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      user = null;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> saveUserData({
    required String name,
    required String email,
    required String phoneNumber,
    required String gender,
    required DateTime birthday,
  }) async {
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    try {
      final Map<String, dynamic> userData = {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'birthday': birthday.toIso8601String().split('T')[0],
        'level': 'Bronze',
        'notifications': {}
      };

      // Save under users/{userId}
      await _database.child('users/${user!.uid}').set(userData);
      debugPrint(
          'User data saved successfully in Realtime Database under users');
    } catch (e) {
      debugPrint('Error saving user data: $e');
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    if (user == null) return null;

    try {
      final snapshot =
          await _database.child('exam/all_users/${user!.uid}').get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
        return null;
      }
      return null;
    } catch (e) {
      error = e.toString();
      return null;
    }
  }
}
