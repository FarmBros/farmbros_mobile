abstract class PlotProfileState {}

class PlotProfileStateLoadGeoJSON extends PlotProfileState {
  final Map<String, dynamic> plotProfileGeoJson;

  PlotProfileStateLoadGeoJSON({
    this.plotProfileGeoJson = const {},
  });

  PlotProfileStateLoadGeoJSON copyWith({
    Map<String, dynamic>? plotProfileGeoJson,
  }) {
    return PlotProfileStateLoadGeoJSON(
      plotProfileGeoJson: plotProfileGeoJson ?? this.plotProfileGeoJson,
    );
  }
}

class PlotProfileStateLoading extends PlotProfileState {}

class PlotProfileStateSuccess extends PlotProfileState {
  final Map<String, dynamic>? data;

  PlotProfileStateSuccess({this.data});
}

class PlotProfileStateError extends PlotProfileState {
  final String errorMessage;

  PlotProfileStateError({required this.errorMessage});
}
