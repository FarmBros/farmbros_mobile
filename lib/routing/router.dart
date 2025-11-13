import 'package:async/async.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_confirm_exit.dart';
import 'package:farmbros_mobile/core/configs/Helpers/go_stream.dart';
import 'package:farmbros_mobile/presentation/Onboarding/onboarding_controller.dart';
import 'package:farmbros_mobile/presentation/create-farm/create_farm.dart';
import 'package:farmbros_mobile/presentation/create-plot/create_plot.dart';
import 'package:farmbros_mobile/presentation/dashboard/ui/dashboard.dart';
import 'package:farmbros_mobile/presentation/farm-logger/farm_logger.dart';
import 'package:farmbros_mobile/presentation/farm-profile/farm_profile.dart';
import 'package:farmbros_mobile/presentation/farmer_account/account.dart';
import 'package:farmbros_mobile/presentation/farms/farms.dart';
import 'package:farmbros_mobile/presentation/forgot-password/forgot_password.dart';
import 'package:farmbros_mobile/presentation/map/farmbros_map.dart';
import 'package:farmbros_mobile/presentation/plot-profile/plot_profile.dart';
import 'package:farmbros_mobile/presentation/plots/plots.dart';
import 'package:farmbros_mobile/presentation/sign-in/sign_in.dart';
import 'package:farmbros_mobile/presentation/sign-up/sign_up.dart';
import 'package:farmbros_mobile/presentation/verify-email/verify_email.dart';
import 'package:farmbros_mobile/presentation/welcome/welcome_screen.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:farmbros_mobile/service_locator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

GoRouter createRouter(BuildContext context) {
  final sessionCubit = sl<SessionCubit>();
  final onboardingCubit = sl<OnboardingStateCubit>();
  final refresh = GoRouterRefreshStream(
    StreamGroup.merge([sessionCubit.stream, onboardingCubit.stream]),
  );
  Logger logger = Logger();

  return GoRouter(
    initialLocation: Routes.welcome,
    routes: [
      // Standalone Dashboard - back button exits app
      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            final shouldExit = await _showExitDialog(context);
            if (shouldExit) {
              SystemNavigator.pop();
            }
            return false;
          },
          child: const Dashboard(),
        ),
      ),

      // Authentication flow - nested structure
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            final shouldExit = await _showExitDialog(context);
            if (shouldExit) {
              SystemNavigator.pop();
            }
            return false;
          },
          child: const WelcomeScreen(),
        ),
        routes: [
          GoRoute(
            path: 'sign_in',
            builder: (context, state) => const SignIn(),
            routes: [
              GoRoute(
                path: 'forgot_password',
                builder: (context, state) => const ForgotPassword(),
              ),
            ],
          ),
          GoRoute(
            path: 'sign_up',
            builder: (context, state) => const SignUp(),
          ),
          GoRoute(
            path: 'verify_email',
            builder: (context, state) => const VerifyEmail(),
          ),
        ],
      ),

      // Farms flow - nested structure with exit prompt at root
      GoRoute(
        path: Routes.farms,
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            final shouldExit = await _showExitDialog(context);
            if (shouldExit) {
              SystemNavigator.pop();
            }
            return false;
          },
          child: const Farms(),
        ),
        routes: [
          GoRoute(
            path: 'create_farm',
            builder: (context, state) => const CreateFarm(),
            routes: [
              GoRoute(
                path: 'map',
                name: "/farms/create_farm/map",
                builder: (context, state) => const FarmbrosMap(),
              ),
            ],
          ),
          GoRoute(
            path: 'farm_profile/:farm_id',
            builder: (context, state) {
              final farmId = state.pathParameters['farm_id'];
              final extra = state.extra as Map<String, dynamic>?;
              final coordinates = extra?['coordinates'];
              return FarmProfile(farmId: farmId!);
            },
          ),
        ],
      ),

      // Plots flow - nested structure with exit prompt at root
      GoRoute(
        path: Routes.plots,
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            final shouldExit = await _showExitDialog(context);
            if (shouldExit) {
              SystemNavigator.pop();
            }
            return false;
          },
          child: const Plots(),
        ),
        routes: [
          GoRoute(
            path: 'create_plot',
            builder: (context, state) => const CreatePlot(),
            routes: [
              GoRoute(
                path: 'map',
                name: "/plots/create_plot/map",
                builder: (context, state) => const FarmbrosMap(),
              ),
            ],
          ),
          GoRoute(
            path: 'plot_profile/:plot_id',
            builder: (context, state) {
              final plotId = state.pathParameters['plot_id'];
              return PlotProfile(plotId: plotId!);
            },
          ),
        ],
      ),

      GoRoute(
        path: Routes.farmerAccount,
        builder: (context, state) => const Account(),
      ),

      // Farm Logger - standalone
      GoRoute(
        path: Routes.farmLogger,
        builder: (context, state) => const FarmLogger(),
      ),

      // Onboarding - standalone
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingController(),
      ),
    ],
    redirect: (context, state) {
      final session = sessionCubit.state;
      final onboardedState = onboardingCubit.state;

      final isAuthed = session is ValidSessionState;
      logger.log(Level.info, isAuthed);

      final isOnboarded = onboardedState is UserOnboardingStatusState
          ? onboardedState.isOnboarded
          : false;

      final loc = state.matchedLocation;

      // --- Group routes by category ---
      const authScreens = {
        Routes.welcome,
        '/welcome/sign_in',
        '/welcome/sign_up',
        '/welcome/verify_email',
        '/welcome/sign_in/forgot_password',
      };

      const openScreens = {
        Routes.map,
      };

      const protectedScreens = {
        Routes.dashboard,
        Routes.farms,
        Routes.plots,
        Routes.farmLogger,
      };

      // --- Rules ---
      if (openScreens.contains(loc)) return null;

      // If authenticated but not onboarded, redirect to onboarding
      // if (isAuthed && !isOnboarded && loc != Routes.onboarding) {
      //   return Routes.onboarding;
      // }

      // If authenticated and trying to access auth screens, go to dashboard
      if (isAuthed && authScreens.any((screen) => loc.startsWith(screen))) {
        return Routes.dashboard;
      }

      // If not authenticated and trying to access protected screens, go to sign in
      if (!isAuthed &&
          protectedScreens.any((screen) => loc.startsWith(screen))) {
        // Check if user has seen welcome screen (you can store this in shared preferences)
        // For now, assuming they have if they're trying to access protected screens
        return '/welcome/sign_in';
      }

      return null; // no redirect
    },
    refreshListenable: refresh,
  );
}

Future<bool> _showExitDialog(BuildContext context) async {
  return await FarmBrosConfirmExit.show(context);
}
