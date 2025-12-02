import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/plant_a_crop_details_params.dart';
import 'package:farmbros_mobile/data/source/planted_crop_service.dart';

class PlantACropUseCase implements Usecases<Either, PlantACropDetailsParams> {
  final PlantedCropService service;

  PlantACropUseCase(this.service);

  @override
  Future<Either> call({PlantACropDetailsParams? param}) async {
    return await service.plantACrop(param!);
  }
}
