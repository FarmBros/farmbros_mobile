import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state.dart';
import 'package:farmbros_mobile/core/usecases/nonparamsusescase.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class PlotStateCubit extends Cubit<PlotState> {
  PlotStateCubit() : super(PlotStateLoading());

  Logger logger = Logger();

  void setPlotGeoJson(Map<String, dynamic> geoJson) {
    emit(PlotStateLoadGeoJSON(plotGeoJson: geoJson));
  }

  void clearPlotGeoJson() {
    emit(PlotStateLoadGeoJSON(plotGeoJson: {}));
  }

  void execute(dynamic params, Usecases usecases) async {
    emit(PlotStateLoading());

    try {
      Either result = await usecases.call(param: params);

      result.fold(
        (error) {
          emit(PlotStateError(errorMessage: error.toString()));
        },
        (data) {
          logger.log(Level.info, data);
          emit(PlotStateSuccess(data: data));
        },
      );
    } catch (e) {
      emit(PlotStateError(errorMessage: e.toString()));
    }
  }
}
