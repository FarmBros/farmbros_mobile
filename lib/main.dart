import 'package:farmbros_mobile/common/bloc/form/combined_form_cubit.dart';
import 'package:farmbros_mobile/common/bloc/serverStatus/server_status_state.dart';
import 'package:farmbros_mobile/common/bloc/serverStatus/server_status_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/server_down_overlay.dart';
import 'package:farmbros_mobile/domain/usecases/server_status_usecase.dart';
import 'package:farmbros_mobile/routing/router.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  final sessionCubit = sl<SessionCubit>();
  await sessionCubit.checkSession();

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
            return Stack(
              children: [
                child!, // Your main app
                if (state is ServerDownState)
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
          },
        );
      },
    );
  }
}
