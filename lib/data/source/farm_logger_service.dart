import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/models/crop_logger_details_params.dart';
import 'package:logger/logger.dart';
import 'package:farmbros_mobile/service_locator.dart';

abstract class FarmLoggerAPIService {
  Future<Either> fetchAllCrops(CropLoggerDetailsParams cropLoggerDetailsParams);
}

class FarmLoggerAPIServiceImpl extends FarmLoggerAPIService {
  Logger logger = Logger();

  @override
  Future<Either> fetchAllCrops(
      CropLoggerDetailsParams cropLoggerDetailsParams) async {
    try {
      var response = await sl<DioClient>()
          .post(AppUtils.$getAllCrops, data: cropLoggerDetailsParams.toJson());

      final responseData = response.data;

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(
            responseData["message"] ?? "Action Failed! Crops not Found");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! Crops not Found";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }
}
