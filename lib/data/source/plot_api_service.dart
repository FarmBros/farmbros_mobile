import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_plots_params.dart';
import 'package:farmbros_mobile/data/models/plot_details_params.dart';
import 'package:farmbros_mobile/data/models/plot_profile_details_params.dart';
import 'package:logger/logger.dart';
import 'package:farmbros_mobile/service_locator.dart';

abstract class PlotApiService {
  Future<Either> savePlotDetails(PlotDetailsParams plotDetailsParams);

  Future<Either> fetchFarmPlots(FetchPlotDetailsParams plotParams);

  Future<Either> getPlotProfileDetails(
      PlotProfileDetailsParams plotProfileParams);
}

class PlotApiServiceImpl extends PlotApiService {
  Logger logger = Logger();

  @override
  Future<Either> savePlotDetails(PlotDetailsParams plotDetailsParams) async {
    if (plotDetailsParams.name == "" ||
        plotDetailsParams.farmId == "" ||
        plotDetailsParams.notes == "" ||
        plotDetailsParams.plotNumber == "" ||
        plotDetailsParams.plotType == "" ||
        plotDetailsParams.geoJson.isEmpty ||
        plotDetailsParams.plotTypeData.isEmpty) {
      return Left("All fields are required");
    }

    try {
      var response = await sl<DioClient>()
          .post(AppUtils.$savePlot, data: plotDetailsParams.toJson());

      final responseData = response.data;

      logger.log(Level.info, responseData);

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(
            responseData["message"] ?? "Action Failed! Plot not Created");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! Plot not Created";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }

  @override
  Future<Either> fetchFarmPlots(FetchPlotDetailsParams plotParams) async {
    try {
      var response = await sl<DioClient>()
          .post(AppUtils.$getFarmPlots, data: plotParams.toJson());

      final responseData = response.data;

      logger.log(Level.info, responseData);

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(
            responseData["message"] ?? "Action Failed! Plots not Found");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! Plots not Found";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }

  @override
  Future<Either> getPlotProfileDetails(
      PlotProfileDetailsParams plotProfileParams) async {
    try {
      var response = await sl<DioClient>()
          .post(AppUtils.$getPlot, data: plotProfileParams.toJson());

      final responseData = response.data;

      logger.log(Level.info, responseData);

      if (responseData["status"] == "success") {
        return Right(responseData);
      } else {
        return Left(responseData["message"] ?? "Action Failed! Plot not Found");
      }
    } on DioException catch (e) {
      String errorMessage = "Action Failed! Plot not Found";
      if (e.response?.data != null && e.response!.data["message"] != null) {
        errorMessage = e.response!.data["message"];
      }
      return Left(errorMessage);
    } catch (e) {
      return Left("An unexpected error occurred");
    }
  }
}
