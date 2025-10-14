import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/models/farm_details_params.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_details_params.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:logger/logger.dart';

abstract class FarmApiService {
  Future<Either> saveFarmDetails(FarmDetailsParams farmDetailsParams);

  Future<Either> fetchMyFarmDetails();

  Future<Either> getFarmDetails(FetchFarmDetailsParams fetchFarmDetailsParams);
}

class FarmApiServiceImpl extends FarmApiService {
  Logger logger = Logger();

  @override
  Future<Either> saveFarmDetails(FarmDetailsParams farmDetailsParams) async {
    logger.log(Level.info, farmDetailsParams.geoJson);
    try {
      var response = await sl<DioClient>()
          .post(AppUtils.$saveFarm, data: farmDetailsParams.toJson());

      final responseData = response.data;

      logger.log(Level.info, responseData);

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(
            responseData["message"] ?? "Action Failed! Farm not Created");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! Farm not Created";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }

  @override
  Future<Either> fetchMyFarmDetails() async {
    try {
      var response = await sl<DioClient>().post(AppUtils.$getMyFarms);

      final responseData = response.data;

      logger.log(Level.info, responseData);

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(
            responseData["message"] ?? "Action Failed! Farms not Found");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! Farms not Found";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }

  @override
  Future<Either> getFarmDetails(
      FetchFarmDetailsParams fetchFarmDetailsParams) async {
    try {
      var response = await sl<DioClient>()
          .post(AppUtils.$getFarm, data: fetchFarmDetailsParams.toJson());

      final responseData = response.data;

      logger.log(Level.info, responseData);

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(
            responseData["message"] ?? "Action Failed! Farm not Found");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! Farm not Found";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }
}
