// combined_form_state.dart
abstract class CombinedFormState {}

class FormInitialState extends CombinedFormState {}

class FormLoadingState extends CombinedFormState {}

class FormSuccessState extends CombinedFormState {}

class FormErrorState extends CombinedFormState {
  final Map<String, String> fieldErrors;
  final String? generalError;

  FormErrorState({
    this.fieldErrors = const {},
    this.generalError,
  });
}
