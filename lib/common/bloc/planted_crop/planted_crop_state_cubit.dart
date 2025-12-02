import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/planted_crop/planted_crop_state.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlantedCropStateCubit extends Cubit<PlantedCropState> {
  PlantedCropStateCubit() : super(PlantedCropStateLoading());

  void plantACrop(dynamic params, Usecases usecases) async {
    emit(PlantedCropStateLoading());
    try {
      Either result = await usecases.call(param: params);
      result.fold((error) {
        emit(PlantedCropStateError(errorMessage: error.toString()));
      }, (data) {
        final Map plantedCrop = data['data'] ?? [];
        emit(PlantedCropStateSuccess());
        emit(PlantedCropStateSetPlantedCrop(plantedCrop: plantedCrop));
      });
    } catch (e) {
      emit(PlantedCropStateError(errorMessage: "Error planting crop: $e"));
    }
  }

  void getAllPlantedCrops(Nonparamsusescase<Either<dynamic, dynamic>> nonParams) async {
    emit(PlantedCropStateLoading());
    try {
      Either result = await nonParams.call();
      result.fold((error) {
        emit(PlantedCropStateError(errorMessage: error.toString()));
      }, (data) {
        final List plantedCrops = data['data'] ?? [];
        emit(PlantedCropStateSuccess());
        emit(PlantedCropStateSetPlantedCrops(plantedCrops: plantedCrops));
      });
    } catch (e) {
      emit(PlantedCropStateError(
          errorMessage: "Error fetching planted crops: $e"));
    }
  }
}
