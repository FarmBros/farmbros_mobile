abstract class ServerStatusState {}

class ServerStatusLoading extends ServerStatusState {}

class ServerUpState extends ServerStatusState {}

class ServerDownState extends ServerStatusState {
  final String serverDownMessage;
  ServerDownState({required this.serverDownMessage});
}
