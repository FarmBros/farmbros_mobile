import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_plots_params.dart';
import 'package:farmbros_mobile/data/models/plot_details_params.dart';
import 'package:farmbros_mobile/data/models/plot_profile_details_params.dart';

abstract class PlotDetailsRepository {
  Future<Either> savePlotDetails(PlotDetailsParams plotDetailsParams);

  Future<Either> fetchFarmPlots(FetchPlotDetailsParams plotParams);

  Future<Either> getPlotProfileDetails(PlotProfileDetailsParams plotProfileParams);
}
