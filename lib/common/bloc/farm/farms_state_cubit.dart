import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/farm/farms_state.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class FarmsStateCubit extends Cubit<FarmsState> {
  FarmsStateCubit() : super(FarmsStateLoading());

  Logger logger = Logger();

  void setFarmGeoJson(Map<String, dynamic> geoJson) {
    emit(FarmsStateLoadGeoJSON(farmsGeoJson: geoJson));
  }

  void clearFarmGeoJson() {
    emit(FarmsStateLoadGeoJSON(farmsGeoJson: {}));
  }

  void execute(dynamic params, Usecases usecases) async {
    emit(FarmsStateLoading());

    try {
      Either result = await usecases.call(param: params);

      result.fold(
        (error) {
          emit(FarmsStateError(errorMessage: error.toString()));
        },
        (data) {
          final List farms = data['data'] ?? [];
          emit(FarmsStateSuccess(
              farms: farms)); // You might want to pass data here too
        },
      );
    } catch (e) {
      emit(FarmsStateError(errorMessage: e.toString()));
    }
  }

  Future<void> fetch(
      Nonparamsusescase<Either<dynamic, dynamic>> nonparams) async {
    emit(FarmsStateLoading());

    try {
      Either result = await nonparams.call();

      result.fold(
        (error) {
          emit(FarmsStateError(errorMessage: error.toString()));
        },
        (data) {
          final List<dynamic> farms = data['data'] ?? [];
          emit(FarmsStateSuccess(farms: farms));
        },
      );
    } catch (e) {
      emit(FarmsStateError(errorMessage: e.toString()));
    }
  }
}
