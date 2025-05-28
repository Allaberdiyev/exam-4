import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/entities/user.dart' as app;

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String birthday,
    required String phoneNumber,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      final userData = app.User(
        id: user.uid,
        name: name,
        email: email,
        gender: gender,
        birthday: birthday,
        phoneNumber: phoneNumber,
        level: 'Standard',
      );

      await _firestore.collection('users').doc(user.uid).set(userData.toJson());
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<app.User?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists) {
        return app.User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          gender: '',
          birthday: '',
          phoneNumber: firebaseUser.phoneNumber ?? '',
          level: 'Standard',
        );
      }
      return app.User.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<app.User> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return app.User.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<void> updateUserData(app.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }
}
