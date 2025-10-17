class FetchPlotDetailsParams {
  final String farmId;
  final bool includeGeoJson;
  final int skip;
  final int limit;

  const FetchPlotDetailsParams(
      {required this.farmId,
      required this.includeGeoJson,
      required this.skip,
      required this.limit});

  Map<String, dynamic> toJson() => {
        "farm_id": farmId,
        "include_geojson": includeGeoJson,
        "skip": skip,
        "limit": limit
      };
}
