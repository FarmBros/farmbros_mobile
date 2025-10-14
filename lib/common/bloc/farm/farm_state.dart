abstract class FarmState {}

class FarmStateLoadGeoJSON extends FarmState {
  final Map<String, dynamic> farmGeoJson;

  FarmStateLoadGeoJSON({
    this.farmGeoJson = const {},
  });

  FarmStateLoadGeoJSON copyWith({
    Map<String, dynamic>? farmGeoJson,
  }) {
    return FarmStateLoadGeoJSON(
      farmGeoJson: farmGeoJson ?? this.farmGeoJson,
    );
  }
}

class FarmStateLoading extends FarmState {}

class FarmStateSuccess extends FarmState {
  final List<dynamic>? farms;
  final Map? farm;

  FarmStateSuccess({this.farms, this.farm});
}

class FarmStateError extends FarmState {
  final String errorMessage;

  FarmStateError({required this.errorMessage});
}
