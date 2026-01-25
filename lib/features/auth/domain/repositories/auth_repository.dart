abstract class AuthRepository {
  Future<void> signIn({required String email, required String password});

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendResetPasswordEmail({required String email});
}
