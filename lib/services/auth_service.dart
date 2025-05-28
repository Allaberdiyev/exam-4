import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String birthday,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create user data in Realtime Database
        final userData = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          gender: gender,
          birthday: birthday,
          phoneNumber: phoneNumber,
          level: 'Standard',
        );

        await _db
            .child('exam')
            .child('users')
            .child(userCredential.user!.uid)
            .set(userData.toJson());

        _error = null;
      }
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An error occurred during sign up';
      debugPrint('Sign up error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An error occurred during sign in';
      debugPrint('Sign in error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = 'An error occurred during sign out';
      debugPrint('Sign out error: $e');
    }
  }

  Future<UserModel?> getUserData() async {
    if (_user == null) return null;

    try {
      final snapshot =
          await _db.child('exam').child('users').child(_user!.uid).get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  Future<void> updateUserData(UserModel userData) async {
    if (_user == null) return;

    try {
      await _db
          .child('exam')
          .child('users')
          .child(_user!.uid)
          .update(userData.toJson());
    } catch (e) {
      _error = 'An error occurred while updating user data';
      debugPrint('Update user data error: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
