class SignInReqParams {
  final String username;
  final String password;

  SignInReqParams({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"username": username, "password": password};
  }
}
