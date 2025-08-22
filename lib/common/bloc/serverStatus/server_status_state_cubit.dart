import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/serverStatus/server_status_state.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServerStatusStateCubit extends Cubit<ServerStatusState> {
  ServerStatusStateCubit() : super(ServerUpState());

  void execute(Nonparamsusescase<Either<String, bool>> nonparamsusescase) async {
    try {
      final Either<String, bool> serverStatus = await nonparamsusescase.call();
      serverStatus.fold(
        (error) => emit(ServerDownState(serverDownMessage: error)),
        (_) => emit(ServerUpState()),
      );
    } catch (e) {
      emit(ServerDownState(serverDownMessage: e.toString()));
    }
  }
}


