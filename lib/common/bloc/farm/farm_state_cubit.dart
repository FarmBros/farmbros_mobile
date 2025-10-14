import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/farm/farm_state.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class FarmStateCubit extends Cubit<FarmState> {
  FarmStateCubit() : super(FarmStateLoading());

  Logger logger = Logger();

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
          final Map farm = data['data'] ?? [];
          emit(FarmStateSuccess(
              farm: farm)); // You might want to pass data here too
        },
      );
    } catch (e) {
      emit(FarmStateError(errorMessage: e.toString()));
    }
  }

  Future<void> fetch(
      Nonparamsusescase<Either<dynamic, dynamic>> nonparams) async {
    emit(FarmStateLoading());

    try {
      Either result = await nonparams.call();

      result.fold(
        (error) {
          emit(FarmStateError(errorMessage: error.toString()));
        },
        (data) {
          final List<dynamic> farms = data['data'] ?? [];
          emit(FarmStateSuccess(farms: farms));
        },
      );
    } catch (e) {
      emit(FarmStateError(errorMessage: e.toString()));
    }
  }
}
