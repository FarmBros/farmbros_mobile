import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:farmbros_mobile/data/models/farm_details_params.dart';
import 'package:farmbros_mobile/data/models/plot_details_params.dart';
import 'package:farmbros_mobile/domain/repository/farm_details_repository.dart';
import 'package:farmbros_mobile/domain/repository/plot_details_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class SavePlotUseCase implements Usecases<Either, PlotDetailsParams> {
  @override
  Future<Either> call({PlotDetailsParams? param}) {
    return sl<PlotDetailsRepository>().savePlotDetails(param!);
  }
}
