class PlotDetailsParams {
  final String name;
  final String farmId;
  final String? notes;
  final String? plotNumber;
  final String? plotType;
  final Map<dynamic, dynamic> geoJson;
  final Map<String, dynamic> plotTypeData;

  const PlotDetailsParams(
      {required this.name,
      required this.farmId,
      required this.notes,
      required this.plotNumber,
      required this.plotType,
      required this.geoJson,
      required this.plotTypeData});

  Map<String, dynamic> toJson() => {
        "name": name,
        "farm_id": farmId,
        "plot_number": plotNumber,
        "plot_type": plotType,
        "notes": notes ?? "",
        "geojson": geoJson,
        "plot_type_data": plotTypeData
      };
}
