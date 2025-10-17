import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_plots_params.dart';
import 'package:farmbros_mobile/data/source/plot_api_service.dart';
import 'package:farmbros_mobile/domain/repository/plot_details_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class FetchFarmPlotsUsecase
    implements Usecases<Either, FetchPlotDetailsParams> {
  @override
  Future<Either> call({FetchPlotDetailsParams? param}) {
    return sl<PlotDetailsRepository>().fetchFarmPlots(param!);
  }
}
