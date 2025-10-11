class FarmDetailsParams {
  final String name;
  final String? description;
  final Map<String, dynamic> geoJson;

  const FarmDetailsParams({
    required this.name,
    this.description,
    required this.geoJson,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description ?? "",
    "geo_json": geoJson,
  };
}
