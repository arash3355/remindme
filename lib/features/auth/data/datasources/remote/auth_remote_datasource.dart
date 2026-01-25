import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this.client);
  final SupabaseClient client;

  Future<void> signIn({required String email, required String password}) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    await client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<void> sendResetPasswordEmail({required String email}) async {
    await client.auth.resetPasswordForEmail(email);
  }
}
