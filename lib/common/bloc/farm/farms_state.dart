abstract class FarmsState {}

class FarmsStateLoadGeoJSON extends FarmsState {
  final Map<String, dynamic> farmsGeoJson;

  FarmsStateLoadGeoJSON({
    this.farmsGeoJson = const {},
  });

  FarmsStateLoadGeoJSON copyWith({
    Map<String, dynamic>? farmsGeoJson,
  }) {
    return FarmsStateLoadGeoJSON(
      farmsGeoJson: farmsGeoJson ?? this.farmsGeoJson,
    );
  }
}

class FarmsStateLoading extends FarmsState {}

class FarmsStateSuccess extends FarmsState {
  final List<dynamic>? farms;

  FarmsStateSuccess({this.farms});
}

class FarmsStateError extends FarmsState {
  final String errorMessage;

  FarmsStateError({required this.errorMessage});
}
