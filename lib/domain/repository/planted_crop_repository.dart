import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/plant_a_crop_details_params.dart';

abstract class PlantedCropRepository {
  Future<Either> plantACrop(PlantACropDetailsParams plantACropDetailsParams);

  Future<Either> getAllPlantedCrops();
}
