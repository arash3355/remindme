class AuthUiState {
  final bool isLoading;
  final String? errorMessage;

  const AuthUiState({this.isLoading = false, this.errorMessage});

  AuthUiState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
