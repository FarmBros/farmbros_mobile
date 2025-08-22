abstract class ServerStatusState {}

class ServerUpState extends ServerStatusState {}

class ServerDownState extends ServerStatusState {
  final String serverDownMessage;

  ServerDownState({required this.serverDownMessage});
}
