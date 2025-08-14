import 'package:farmbros_mobile/bloc/auth_bloc/auth_provider.dart';
import 'package:farmbros_mobile/bloc/auth_bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(AuthState(
            isSignedIn: false, isFirstLogin: false, isOnboarded: false)) {
    on<SignInEvent>((event, emit) {
      emit(AuthState(isSignedIn: true, isFirstLogin: false, isOnboarded: false));
    });

    on<SignOutEvent>((event, emit) {
      emit(AuthState(
          isSignedIn: false, isFirstLogin: false, isOnboarded: false));
    });
  }
}
