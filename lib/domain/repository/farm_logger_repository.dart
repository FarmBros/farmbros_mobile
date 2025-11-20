import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/crop_logger_details_params.dart';

abstract class FarmLoggerRepository {
  Future<Either> fetchAllCrops(CropLoggerDetailsParams cropLoggerDetailsParams);
}
