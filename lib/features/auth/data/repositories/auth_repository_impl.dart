import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remote);

  final AuthRemoteDatasource remote;

  @override
  Future<void> signIn({required String email, required String password}) {
    return remote.signIn(email: email, password: password);
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    final res = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    if (res.user == null) {
      throw Exception('Signup gagal');
    }
  }

  @override
  Future<void> signOut() {
    return remote.signOut();
  }

  @override
  Future<void> sendResetPasswordEmail({required String email}) {
    return remote.sendResetPasswordEmail(email: email);
  }
}
