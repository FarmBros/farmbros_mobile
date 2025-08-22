import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/button/button_state.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  void execute(dynamic params, Usecases usecases) async {
    emit(ButtonLoadingState());

    try {
      Either result = await usecases.call(param: params);
      result.fold((error) {
        emit(ButtonFailureState(errorMessage: error.toString()));
        _resetToInitialAfterDelay(seconds: 5); // Longer delay for errors
      }, (data) {
        emit(ButtonSuccessState());
        _resetToInitialAfterDelay(seconds: 2); // Shorter delay for success
      });
    } catch (e) {
      emit(ButtonFailureState(errorMessage: e.toString()));
      _resetToInitialAfterDelay(seconds: 5);
    }
  }

  void _resetToInitialAfterDelay({int seconds = 3}) {
    Future.delayed(Duration(seconds: seconds), () {
      if (!isClosed) {
        emit(ButtonInitialState());
      }
    });
  }
}
