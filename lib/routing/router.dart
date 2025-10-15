import 'package:async/async.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/core/configs/Helpers/go_stream.dart';
import 'package:farmbros_mobile/presentation/Onboarding/onboarding_controller.dart';
import 'package:farmbros_mobile/presentation/create-farm/create_farm.dart';
import 'package:farmbros_mobile/presentation/dashboard/ui/dashboard.dart';
import 'package:farmbros_mobile/presentation/farm-logger/farm_logger.dart';
import 'package:farmbros_mobile/presentation/farm-profile/farm_profile.dart';
import 'package:farmbros_mobile/presentation/farms/farms.dart';
import 'package:farmbros_mobile/presentation/forgot-password/forgot_password.dart';
import 'package:farmbros_mobile/presentation/map/farmbros_map.dart';
import 'package:farmbros_mobile/presentation/plots/plots.dart';
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
          path: Routes.farms,
          builder: (context, state) => const Farms(),
          routes: [
            GoRoute(
                path: Routes.createFarm,
                builder: (context, state) => const CreateFarm(),
                routes: [
                  GoRoute(
                      path: Routes.map,
                      name: "/farms/create_farm/map",
                      builder: (context, state) => const FarmbrosMap())
                ]),
            GoRoute(
                path: Routes.farmProfile,
                builder: (context, state) {
                  final farmId = state.pathParameters['farm_id'];
                  final extra = state.extra as Map<String, dynamic>?;
                  final coordinates = extra?['coordinates'];
                  return FarmProfile(farmId: farmId!);
                })
          ]),
      GoRoute(path: Routes.plots, builder: (context, state) => const Plots()),
      GoRoute(
          path: Routes.farmLogger,
          builder: (context, state) => const FarmLogger()),
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
          builder: (context, state) => const OnboardingController()),
    ],
    redirect: (context, state) {
      final s = sessionCubit.state;
      final ob = onboardingCubit.state;

      final isAuthed = s is ValidSessionState;
      final isOnboarded =
          ob is UserOnboardingStatusState ? ob.isOnboarded : false;

      final loc = state.matchedLocation;

      // --- Group routes by category ---
      const authScreens = {
        Routes.welcome,
        Routes.signIn,
        Routes.signUp,
        Routes.verifyEmail,
        Routes.forgotPassword,
      };

      const openScreens = {
        Routes.map,
      };

      const protectedScreens = {
        Routes.dashboard,
        Routes.farms,
        Routes.createFarm,
        Routes.farmProfile,
        Routes.farmLogger
        // add others here if you want them locked
      };

      // --- Rules ---
      if (openScreens.contains(loc)) return null;

      // if (isAuthed && !isOnboarded && loc != Routes.onboarding) {
      //   return Routes.onboarding;
      // }

      if (isAuthed && authScreens.contains(loc)) {
        return Routes.dashboard;
      }

      if (!isAuthed && protectedScreens.contains(loc)) {
        return Routes.signIn;
      }

      return null; // no redirect
    },
    refreshListenable: refresh,
  );
}
