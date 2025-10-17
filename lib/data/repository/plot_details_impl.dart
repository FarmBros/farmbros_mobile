import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_plots_params.dart';
import 'package:farmbros_mobile/data/models/plot_details_params.dart';
import 'package:farmbros_mobile/data/source/plot_api_service.dart';
import 'package:farmbros_mobile/domain/repository/plot_details_repository.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farm_plots_use_case.dart';
import 'package:farmbros_mobile/service_locator.dart';

class PlotDetailsImpl extends PlotDetailsRepository {
  @override
  Future<Either> savePlotDetails(PlotDetailsParams plotDetailsParams) async {
    return sl<PlotApiService>().savePlotDetails(plotDetailsParams);
  }

  @override
  Future<Either> fetchFarmPlots(FetchPlotDetailsParams plotParams) async {
    return sl<PlotApiService>().fetchFarmPlots(plotParams);
  }
}
