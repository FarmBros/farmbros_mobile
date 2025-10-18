import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/form/combined_form_cubit.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_profile_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/serverStatus/server_status_state.dart';
import 'package:farmbros_mobile/common/bloc/serverStatus/server_status_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_loader.dart';
import 'package:farmbros_mobile/common/widgets/server_down_overlay.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farms_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/server_status_usecase.dart';
import 'package:farmbros_mobile/presentation/farms/farms.dart';
import 'package:farmbros_mobile/routing/router.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChannels.platform
      .invokeMethod('SystemNavigator.selectHybridComposition');

  await dotenv.load(fileName: "assets/config/.env");

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
          create: (context) =>
              sl<FarmStateCubit>()..fetch(sl<FetchFarmsUsecase>()),
          child: Farms(),
        ),
        BlocProvider(create: (_) => PlotStateCubit()),
        BlocProvider(create: (_) => PlotProfileStateCubit()),
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
                  FarmbrosLoader(),
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
              return child!;
            }
            return child!;
          },
        );
      },
    );
  }
}
