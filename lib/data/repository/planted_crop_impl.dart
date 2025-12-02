import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/plant_a_crop_details_params.dart';
import 'package:farmbros_mobile/data/source/planted_crop_service.dart';
import 'package:farmbros_mobile/domain/repository/planted_crop_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class PlantedCropImpl extends PlantedCropRepository {
  @override
  Future<Either> plantACrop(
      PlantACropDetailsParams plantACropDetailsParams) async {
    return sl<PlantedCropService>().plantACrop(plantACropDetailsParams);
  }

  @override
  Future<Either> getAllPlantedCrops() async {
    return sl<PlantedCropService>().getAllPlantedCrops();
  }
}
