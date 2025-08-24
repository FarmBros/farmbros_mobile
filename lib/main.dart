import 'package:farmbros_mobile/common/bloc/form/combined_form_cubit.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/serverStatus/server_status_state.dart';
import 'package:farmbros_mobile/common/bloc/serverStatus/server_status_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_loader.dart';
import 'package:farmbros_mobile/common/widgets/server_down_overlay.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/usecases/server_status_usecase.dart';
import 'package:farmbros_mobile/routing/router.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  final sessionCubit = sl<SessionCubit>();
  final onboardingCubit = sl<OnboardingStateCubit>();
  await sessionCubit.checkSession();
  await onboardingCubit.verifyOnboardingStatus();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CombinedFormCubit()),
        BlocProvider(create: (_) => SessionCubit()),
        BlocProvider(create: (_) => OnboardingStateCubit()),
        BlocProvider(
          create: (_) {
            final cubit = ServerStatusStateCubit();
            cubit.execute(sl<ServerStatusUsecase>()); // check server on startup
            return cubit;
          },
        ),
      ],
      child: const _AppRouterWrapper(),
    );
  }
}

class _AppRouterWrapper extends StatelessWidget {
  const _AppRouterWrapper();

  @override
  Widget build(BuildContext context) {
    final router = createRouter(context);

    return MaterialApp.router(
      title: 'Farmbros Mobile',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return BlocBuilder<ServerStatusStateCubit, ServerStatusState>(
          builder: (ctx, state) {
            if (state is ServerStatusLoading) {
              return FarmbrosLoader();
            } else if (state is ServerDownState) {
              // Show splash background + overlay
              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/splash_screen.png"),
                      ),
                    ),
                  ),
                  ServerDownOverlay(
                    message: state.serverDownMessage,
                    onRetry: () {
                      ctx.read<ServerStatusStateCubit>().execute(
                            sl<ServerStatusUsecase>(),
                          );
                    },
                  ),
                ],
              );
            } else if (state is ServerUpState) {
              return FarmbrosLoader();
            }
            return FarmbrosLoader();
          },
        );
      },
    );
  }
}
