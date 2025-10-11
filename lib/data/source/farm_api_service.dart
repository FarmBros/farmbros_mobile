import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/models/farm_details_params.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:logger/logger.dart';

abstract class FarmApiService {
  Future<Either> saveFarmDetails(FarmDetailsParams farmDetailsParams);
}

class FarmApiServiceImpl extends FarmApiService {
  Logger logger = Logger();

  @override
  Future<Either> saveFarmDetails(FarmDetailsParams farmDetailsParams) async {
    logger.log(Level.info, farmDetailsParams.geoJson);
    try {
      var response = await sl<DioClient>()
          .post(
          AppUtils.$saveFarm, data: farmDetailsParams.toJson());

      final responseData = response.data;

      logger.log(Level.info, responseData);

      if (responseData["status"] == "success") {
        final token = responseData["data"];
        logger.log(Level.info, token);

        // await sl<SessionCubit>().createSession(token);

        return Right(responseData);
      } else {
        return Left(responseData["message"] ?? "Login failed");
      }
    } on DioException catch (e) {
      String errorMessage = "Login failed";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }
}