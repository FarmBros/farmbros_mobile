import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_profile_state.dart';
import 'package:farmbros_mobile/core/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class PlotProfileStateCubit extends Cubit<PlotProfileState> {
  PlotProfileStateCubit() : super(PlotProfileStateLoading());

  Logger logger = Logger();

  // void setPlotGeoJson(Map<String, dynamic> geoJson) {
  //   emit(PlotProfileStateLoadGeoJSON(plotGeoJson: geoJson));
  // }
  //
  // void clearPlotGeoJson() {
  //   emit(PlotProfileStateLoadGeoJSON(plotGeoJson: {}));
  // }

  void execute(dynamic params, Usecases usecases) async {
    emit(PlotProfileStateLoading());

    try {
      Either result = await usecases.call(param: params);

      result.fold(
            (error) {
          emit(PlotProfileStateError(errorMessage: error.toString()));
        },
            (data) {
          logger.log(Level.info, data);
          emit(PlotProfileStateSuccess(data: data));
        },
      );
    } catch (e) {
      emit(PlotProfileStateError(errorMessage: e.toString()));
    }
  }
}
