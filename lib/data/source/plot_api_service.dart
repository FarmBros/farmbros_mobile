import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:farmbros_mobile/core/configs/Utils/app_utils.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_plots_params.dart';
import 'package:farmbros_mobile/data/models/plot_details_params.dart';
import 'package:logger/logger.dart';
import 'package:farmbros_mobile/service_locator.dart';

abstract class PlotApiService {
  Future<Either> savePlotDetails(PlotDetailsParams plotDetailsParams);

  Future<Either> fetchFarmPlots(FetchPlotDetailsParams plotParams);
}

class PlotApiServiceImpl extends PlotApiService {
  Logger logger = Logger();

  @override
  Future<Either> savePlotDetails(PlotDetailsParams plotDetailsParams) async {
    logger.log(Level.info, plotDetailsParams.toJson());
    try {
      var response = await sl<DioClient>()
          .post(AppUtils.$savePlot, data: plotDetailsParams.toJson());

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
}
