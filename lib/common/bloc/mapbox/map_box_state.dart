abstract class MapBoxState {}

class LoadingMapBox extends MapBoxState {}

class MapBoxInitSuccess extends MapBoxState {}

class MapBoxInitFailure extends MapBoxState {
  final String initializationError;

  MapBoxInitFailure({required this.initializationError});
}
