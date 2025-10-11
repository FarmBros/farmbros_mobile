import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/farm_bros_map/farm_bros_map_state.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FarmBrosStateCubit extends Cubit<FarmBrosMapState> {
  FarmBrosStateCubit() : super(LoadingFarmBrosMap());

  void execute(dynamic params, Usecases usecases) async {
    emit(LoadingFarmBrosMap());

    try {
      Either result = await usecases.call(param: params);

      result.fold(
        (error) {
          emit(FarmBrosMapInitFailure(initializationError: error.toString()));
        },
        (data) {
          emit(FarmBrosMapInitSuccess());
        },
      );
    } catch (e) {
      emit(FarmBrosMapInitFailure(initializationError: e.toString()));
    }
  }
}
