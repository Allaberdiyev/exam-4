import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/entities/user.dart' as app;

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  app.User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthViewModel(this._authRepository);

  app.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String birthday,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        name: name,
        gender: gender,
        birthday: birthday,
        phoneNumber: phoneNumber,
      );
      _currentUser = await _authRepository.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.signIn(email, password);
      _currentUser = await _authRepository.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.signOut();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData(app.User user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.updateUserData(user);
      _currentUser = user;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
