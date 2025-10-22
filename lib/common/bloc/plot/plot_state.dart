abstract class PlotState {}

class PlotStateLoadGeoJSON extends PlotState {
  final Map<String, dynamic> plotGeoJson;

  PlotStateLoadGeoJSON({
    this.plotGeoJson = const {},
  });

  PlotStateLoadGeoJSON copyWith({
    Map<String, dynamic>? plotGeoJson,
  }) {
    return PlotStateLoadGeoJSON(
      plotGeoJson: plotGeoJson ?? this.plotGeoJson,
    );
  }
}

class PlotStateLoading extends PlotState {}

class PlotStateSuccess extends PlotState {
  final data;

  PlotStateSuccess({this.data});
}

class PlotStateError extends PlotState {
  final String errorMessage;

  PlotStateError({required this.errorMessage});
}
