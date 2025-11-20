import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/farm_logger/crop_logger_state.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class CropLoggerStateCubit extends Cubit<CropLoggerState> {
  CropLoggerStateCubit() : super(CropLoggerStateLoading());

  Logger logger = Logger();

  void fetchAllCrops(dynamic params, Usecases usecases) async {
    emit(CropLoggerStateLoading());

    try {
      Either result = await usecases.call(param: params);

      result.fold((error) {
        emit(CropLoggerStateError(errorMessage: error.toString()));
      }, (data) {
        final List crops = data['data'] ?? [];
        emit(CropLoggerStateSuccess(crops: crops));
      });
    } catch (e) {
      emit(CropLoggerStateError(errorMessage: e.toString()));
    }
  }
}
