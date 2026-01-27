import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password}) async {
    final res = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    if (res.user == null) {
      throw Exception('Signup gagal');
    }
  }

  Future<void> signOut();

  Future<void> sendResetPasswordEmail({required String email});
}
