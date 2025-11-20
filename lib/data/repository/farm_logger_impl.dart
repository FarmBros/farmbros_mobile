import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/crop_logger_details_params.dart';
import 'package:farmbros_mobile/data/source/farm_logger_service.dart';
import 'package:farmbros_mobile/domain/repository/farm_logger_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class FarmLoggerImpl extends FarmLoggerRepository {
  @override
  Future<Either> fetchAllCrops(
      CropLoggerDetailsParams cropLoggerDetailsParams) async {
    return sl<FarmLoggerAPIService>().fetchAllCrops(cropLoggerDetailsParams);
  }
}
