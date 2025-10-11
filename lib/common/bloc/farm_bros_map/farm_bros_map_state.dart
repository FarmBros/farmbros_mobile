abstract class FarmBrosMapState {}

class LoadingFarmBrosMap extends FarmBrosMapState {}

class FarmBrosMapInitSuccess extends FarmBrosMapState {}

class FarmBrosMapInitFailure extends FarmBrosMapState {
  final String initializationError;

  FarmBrosMapInitFailure({required this.initializationError});
}

