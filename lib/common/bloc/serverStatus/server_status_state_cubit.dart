import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/serverStatus/server_status_state.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServerStatusStateCubit extends Cubit<ServerStatusState> {
  ServerStatusStateCubit() : super(ServerStatusLoading());

  Future<void> execute(
    Nonparamsusescase<Either<String, bool>> nonparamsusescase,
  ) async {
    emit(ServerStatusLoading());

    final startTime = DateTime.now();

    try {
      final result = await nonparamsusescase.call();
      final elapsed = DateTime.now().difference(startTime);

      if (elapsed < const Duration(seconds: 6)) {
        await Future.delayed(const Duration(seconds: 6) - elapsed);
      }

      result.fold(
        (error) => emit(ServerDownState(serverDownMessage: error)),
        (_) => emit(ServerUpState()),
      );
    } catch (e) {
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < const Duration(seconds: 6)) {
        await Future.delayed(const Duration(seconds: 6) - elapsed);
      }

      emit(ServerDownState(serverDownMessage: e.toString()));
    }
  }
}
