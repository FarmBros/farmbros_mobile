// combined_form_cubit.dart
import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/form/comnined_form_state.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CombinedFormCubit extends Cubit<CombinedFormState> {
  CombinedFormCubit() : super(FormInitialState());

  void execute(dynamic params, Usecases usecases) async {
    emit(FormLoadingState());

    try {
      Either result = await usecases.call(param: params);

      result.fold(
        (error) {
          if (error is Map<String, String>) {
            emit(FormErrorState(fieldErrors: error));
          } else {
            emit(FormErrorState(generalError: error.toString()));
          }
          _resetToInitialAfterDelay(seconds: 5);
        },
        (data) {
          emit(FormSuccessState());
          _resetToInitialAfterDelay(seconds: 2);
        },
      );
    } catch (e) {
      emit(FormErrorState(generalError: e.toString()));
      _resetToInitialAfterDelay(seconds: 5);
    }
  }

  void _resetToInitialAfterDelay({int seconds = 3}) {
    Future.delayed(Duration(seconds: seconds), () {
      if (!isClosed) {
        emit(FormInitialState());
      }
    });
  }

  void resetToInitial() {
    emit(FormInitialState());
  }
}
