import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_state.dart';

class OnboardingStateCubit extends Cubit<OnboardingState> {
  OnboardingStateCubit() : super(UserOnboardingStatusState(isOnboarded: false));

  Logger logger = Logger();

  /// Save onboarding status
  Future<void> saveOnboardingStatus({required bool isOnboarded}) async {
    emit(LoadingOnboardingStatus());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_onboarded", isOnboarded);

    emit(UserOnboardingStatusState(isOnboarded: isOnboarded));
  }

  /// Verify onboarding status from SharedPreferences
  Future<void> verifyOnboardingStatus() async {
    emit(LoadingOnboardingStatus());

    final prefs = await SharedPreferences.getInstance();
    final isOnboarded = prefs.getBool("is_onboarded") ?? false;

    logger.log(Level.info, isOnboarded);

    emit(UserOnboardingStatusState(isOnboarded: isOnboarded));
  }

  /// Reset onboarding status
  Future<void> resetOnboardingStatus() async {
    emit(LoadingOnboardingStatus());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_onboarded", false);

    emit(UserOnboardingStatusState(isOnboarded: false));
  }
}
