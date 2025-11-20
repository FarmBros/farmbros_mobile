import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/crop_logger_details_params.dart';
import 'package:farmbros_mobile/data/source/farm_logger_service.dart';

class CropLoggerUseCase implements Usecases<Either, CropLoggerDetailsParams> {
  final FarmLoggerAPIService service;

  CropLoggerUseCase(this.service);

  @override
  Future<Either> call({CropLoggerDetailsParams? param}) async {
    return await service.fetchAllCrops(param!);
  }
}
