import 'package:farmbros_mobile/domain/screens/dashboard/dashboard.dart';
import 'package:farmbros_mobile/domain/screens/forgot-password/forgot_password.dart';
import 'package:farmbros_mobile/domain/screens/sign-in/sign_in.dart';
import 'package:farmbros_mobile/domain/screens/sign-up/sign_up.dart';
import 'package:farmbros_mobile/domain/screens/verify-email/verify_email.dart';
import 'package:farmbros_mobile/domain/screens/welcome/welcome_screen.dart';
import 'package:farmbros_mobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(BuildContext context) {
  final authBloc = BlocProvider.of<AuthBloc>(context);

  return GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
          path:'/dashboard', builder: (context, state) => const Dashboard()),
      GoRoute(
          path:'/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: '/sign_in', builder: (context, state) => const SignIn()),
      GoRoute(path: '/sign_up', builder: (context, state) => const SignUp()),
      GoRoute(
          path: '/verify_email',
          builder: (context, state) => const VerifyEmail()),
      GoRoute(
          path: '/forgot_password',
          builder: (context, state) => const ForgotPassword()),
    ],
    redirect: (context, state) {
      final isSignedIn = authBloc.state.isSignedIn ?? false;
      final isFirstLogin = authBloc.state.isFirstLogin ?? false;

      final loggingIn = state.fullPath == '/sign_in';

      if (isFirstLogin) return '/welcome';
      if (!isSignedIn && !isFirstLogin && !loggingIn) return '/forgot_password';
      if (isSignedIn && loggingIn) return '/dashboard';
      return null;
    },
    // refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}
