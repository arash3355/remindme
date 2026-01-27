import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_state.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthUiState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthUiState> {
  @override
  AuthUiState build() {
    return const AuthUiState();
  }

  // ================= LOGIN =================
  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } on AuthApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Login gagal');
      return false;
    }
  }

  // ================= SIGN UP =================
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username, // 🔑 untuk ProfileScreen
        },
      );

      state = state.copyWith(isLoading: false);
    } on AuthApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      rethrow;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Sign up gagal');
      rethrow;
    }
  }

  // ================= LOGOUT =================
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    state = const AuthUiState();
  }
}
