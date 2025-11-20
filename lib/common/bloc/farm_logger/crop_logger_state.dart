abstract class CropLoggerState {}

class CropLoggerStateLoading extends CropLoggerState {}

class CropLoggerStateSuccess extends CropLoggerState {
  final List<Map<String, dynamic>>? crops;

  CropLoggerStateSuccess({this.crops});
}

class CropLoggerStateError extends CropLoggerState {
  final String errorMessage;

  CropLoggerStateError({required this.errorMessage});
}
