class SignUpReqParams {
  final String username;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String fullName;
  final String password;

  SignUpReqParams({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email,
      "phone_number": phoneNumber,
      "first_name": firstName,
      "last_name": lastName,
      "full_name": fullName,
      "password": password,
    };
  }
}
