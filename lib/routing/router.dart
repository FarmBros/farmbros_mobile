import 'package:farmbros_mobile/presentation/dashboard/ui/dashboard.dart';
import 'package:farmbros_mobile/presentation/forgot-password/forgot_password.dart';
import 'package:farmbros_mobile/presentation/sign-in/ui/sign_in.dart';
import 'package:farmbros_mobile/presentation/sign-up/sign_up.dart';
import 'package:farmbros_mobile/presentation/verify-email/verify_email.dart';
import 'package:farmbros_mobile/presentation/welcome/welcome_screen.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(BuildContext context) {
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
    ],
    // redirect: (context, state) {
    //   final isSignedIn = authBloc.state.isSignedIn ?? false;
    //   final isFirstLogin = authBloc.state.isFirstLogin ?? false;

    //   final loggingIn = state.fullPath == '/sign_in';

    //   if (isFirstLogin) return '/welcome';
    //   if (!isSignedIn && !isFirstLogin && !loggingIn) return '/welcome';
    //   if (isSignedIn && loggingIn) return '/dashboard';
    //   return null;
    // },
    // refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}
