import 'package:async/async.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/core/configs/Helpers/go_stream.dart';
import 'package:farmbros_mobile/presentation/Onboarding/onboarding_controller.dart';
import 'package:farmbros_mobile/presentation/dashboard/ui/dashboard.dart';
import 'package:farmbros_mobile/presentation/forgot-password/forgot_password.dart';
import 'package:farmbros_mobile/presentation/sign-in/sign_in.dart';
import 'package:farmbros_mobile/presentation/sign-up/sign_up.dart';
import 'package:farmbros_mobile/presentation/verify-email/verify_email.dart';
import 'package:farmbros_mobile/presentation/welcome/welcome_screen.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:farmbros_mobile/service_locator.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(BuildContext context) {
  final sessionCubit = sl<SessionCubit>();
  final onboardingCubit = sl<OnboardingStateCubit>();
  final refresh = GoRouterRefreshStream(
    StreamGroup.merge([sessionCubit.stream, onboardingCubit.stream]),
  );

  return GoRouter(
    initialLocation: Routes.welcome,
    routes: [
      GoRoute(
          path: Routes.dashboard,
          builder: (context, state) => const Dashboard()),
      GoRoute(
          path: Routes.welcome,
          builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: Routes.signIn, builder: (context, state) => const SignIn()),
      GoRoute(path: Routes.signUp, builder: (context, state) => const SignUp()),
      GoRoute(
          path: Routes.verifyEmail,
          builder: (context, state) => const VerifyEmail()),
      GoRoute(
          path: Routes.forgotPassword,
          builder: (context, state) => const ForgotPassword()),
      GoRoute(
          path: Routes.onboarding,
          builder: (context, state) => const OnboardingController())
    ],
    redirect: (context, state) {
      final s = sessionCubit.state;
      final ob = onboardingCubit.state;

      final isAuthed = s is ValidSessionState;
      final isOnboarded =
          ob is UserOnboardingStatusState ? ob.isOnboarded : false;

      final loc = state.matchedLocation;
      final isAuthScreen = <String>{
        Routes.welcome,
        Routes.signIn,
        Routes.signUp,
        Routes.verifyEmail,
        Routes.forgotPassword,
      }.contains(loc);

      // Authenticated users should not see auth/onboarding screens
      if (isAuthed && !isOnboarded && loc != Routes.onboarding) {
        return Routes.onboarding; // force onboarding if not completed
      }

      if (isAuthed && isOnboarded && isAuthScreen) {
        return Routes.dashboard;
      }

      // Block access to app if not authenticated
      if (!isAuthed && loc == Routes.dashboard) return Routes.signIn;

      return null; // no redirect
    },
    refreshListenable: refresh,
  );
}
