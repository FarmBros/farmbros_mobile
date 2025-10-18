class PlotProfileDetailsParams {
  final String plotId;

  const PlotProfileDetailsParams({required this.plotId});

  Map<String, dynamic> toJson() => {"plot_id": plotId, "include_geojson": true};
}
