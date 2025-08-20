class SignUpState {
  final bool isLoading;
  final bool isAuthenticated;
  final String username;
  final String email;
  final String firstname;
  final String lastname;
  final String fullname;
  final String bio;
  final String avatarurl;
  final String phonenumber;
  final String timezone;
  final String language;
  final String theme;
  final String password;

  SignUpState({
    required this.isLoading,
    required this.isAuthenticated,
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.fullname,
    required this.bio,
    required this.avatarurl,
    required this.phonenumber,
    required this.timezone,
    required this.language,
    required this.theme,
    required this.password,
  });

  SignUpState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? username,
    String? email,
    String? firstname,
    String? lastname,
    String? fullname,
    String? bio,
    String? avatarurl,
    String? phonenumber,
    String? timezone,
    String? language,
    String? theme,
    String? password,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      fullname: fullname ?? this.fullname,
      bio: bio ?? this.bio,
      avatarurl: avatarurl ?? this.avatarurl,
      phonenumber: phonenumber ?? this.phonenumber,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      password: password ?? this.password,
    );
  }
}
