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
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) {
    return remote.signUp(username: username, email: email, password: password);
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
