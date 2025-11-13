import 'package:farmbros_mobile/common/bloc/session/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());
  Logger logger = Logger();

  Future<void> createSession(String token) async {
    emit(SessionLoading());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);

    emit(ValidSessionState(token: token));
  }

  Future<void> checkSession() async {
    emit(SessionLoading());

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token != null && token.isNotEmpty) {
      final bool isTokenExpired = JwtDecoder.isExpired(token);
      if (isTokenExpired) {
        emit(ExpiredSessionState(reason: "Token expired"));
        return;
      } else {
        emit(ValidSessionState(token: token));
      }
    } else {
      emit(ExpiredSessionState(reason: "No valid token"));
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");

    emit(ExpiredSessionState(reason: "Logged out"));
  }
}
