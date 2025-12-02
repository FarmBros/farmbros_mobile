import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/core/network/endpoints.dart';
import 'package:farmbros_mobile/data/models/plant_a_crop_details_params.dart';
import 'package:farmbros_mobile/service_locator.dart';

abstract class PlantedCropService {
  Future<Either> plantACrop(PlantACropDetailsParams plantACropDetailsParams);

  Future<Either> getAllPlantedCrops();
}

class PlantedCropServiceImpl extends PlantedCropService {
  @override
  Future<Either> plantACrop(
      PlantACropDetailsParams plantACropDetailsParams) async {
    try {
      var response = await sl<DioClient>()
          .post(Endpoints.$savePlantedCrop, data: plantACropDetailsParams);
      final responseData = response.data;

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(
            responseData["message"] ?? "Action Failed! Crop not Planted");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! Crop not Planted";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }

  @override
  Future<Either> getAllPlantedCrops() async {
    try {
      var response =
          await sl<DioClient>().post(Endpoints.$getAllPlantedCrops, data: {});
      final responseData = response.data;

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(responseData["message"] ?? "Action Failed! No Crops");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! No Crops";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }
}
