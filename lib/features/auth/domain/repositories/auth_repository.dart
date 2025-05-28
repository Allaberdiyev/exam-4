import '../../../../core/entities/user.dart' as app;

abstract class AuthRepository {
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String birthday,
    required String phoneNumber,
  });

  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<app.User?> getCurrentUser();
  Future<app.User> getUserById(String userId);
  Future<void> updateUserData(app.User user);
}
