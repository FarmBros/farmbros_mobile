class SignInState {
  final bool isLoading;
  final bool isAuthenticated;
  final String username;
  final String password;

  SignInState({
    required this.isLoading,
    required this.isAuthenticated,
    required this.username,
    required this.password,
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? username,
    String? password,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
