import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/plot_profile_details_params.dart';
import 'package:farmbros_mobile/data/source/plot_api_service.dart';

class PlotProfileUseCase extends Usecases<Either, PlotProfileDetailsParams> {
  final PlotApiService service;

  PlotProfileUseCase(this.service);

  @override
  Future<Either> call({PlotProfileDetailsParams? param}) async {
    return await service.getPlotProfileDetails(param!);
  }
}
