import 'package:farmbros_mobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:farmbros_mobile/bloc/farmbros_button_bloc/button_bloc.dart';
import 'package:farmbros_mobile/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => ButtonBloc())
      ],
      child: const _AppRouterWrapper(),
    );
  }
}

class _AppRouterWrapper extends StatelessWidget {
  const _AppRouterWrapper({super.key});

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
    );
  }
}
