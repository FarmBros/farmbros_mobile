abstract class OnboardingState {}

class LoadingOnboardingStatus extends OnboardingState {}

class UserOnboardingStatusState extends OnboardingState {
  final bool isOnboarded;

  UserOnboardingStatusState({required this.isOnboarded});
}