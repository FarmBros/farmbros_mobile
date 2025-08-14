import 'package:flutter_bloc/flutter_bloc.dart';
import 'button_event.dart';
import 'button_state.dart';

class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
  ButtonBloc()
      : super(ButtonState(
          isLoading: false,
        )) {
    on<ButtonClickEvent>((event, emit) async {
      emit(ButtonState(
        isLoading: true,
      ));

      // Simulate some async process
      await Future.delayed(const Duration(seconds: 2));

      emit(ButtonState(
        isLoading: false,
      ));
    });
  }
}
