abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class ValidSessionState extends SessionState {
  final String token;
  ValidSessionState({required this.token});
}

class ExpiredSessionState extends SessionState {
  final String? reason;
  ExpiredSessionState({this.reason});
}
