import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/data/source/planted_crop_service.dart';

class FetchAllPlantedCropsUseCase
    implements Nonparamsusescase<Either<dynamic, dynamic>> {
  final PlantedCropService service;

  FetchAllPlantedCropsUseCase(this.service);

  @override
  Future<Either> call() async {
    return await service.getAllPlantedCrops();
  }
}
