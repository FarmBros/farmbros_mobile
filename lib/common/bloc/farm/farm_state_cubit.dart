import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/farm/farm_state.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FarmStateCubit extends Cubit<FarmState> {
  FarmStateCubit() : super(FarmStateLoading());

  void setFarmGeoJson(Map<String, dynamic> geoJson) {
    emit(FarmStateLoadGeoJSON(farmGeoJson: geoJson));
  }

  void clearFarmGeoJson() {
    emit(FarmStateLoadGeoJSON(farmGeoJson: {}));
  }

  void execute(dynamic params, Usecases usecases) async {
    emit(FarmStateLoading());

    try {
      Either result = await usecases.call(param: params);

      result.fold(
        (error) {
          emit(FarmStateError(errorMessage: error.toString()));
        },
        (data) {
          emit(FarmStateSuccess());
        },
      );
    } catch (e) {
      emit(FarmStateError(errorMessage: e.toString()));
    }
  }
}
