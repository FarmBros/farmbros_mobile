class FetchFarmDetailsParams {
  final String farmId;

  const FetchFarmDetailsParams({required this.farmId});

  Map<String, dynamic> toJson() => {"farm_id": farmId, "include_geojson": true};
}
