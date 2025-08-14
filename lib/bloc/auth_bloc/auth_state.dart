class AuthState {
  final bool? isSignedIn;
  final bool? isOnboarded;
  final bool? isFirstLogin;

  AuthState(
      {required this.isSignedIn,
      required this.isOnboarded,
      required this.isFirstLogin});
}
