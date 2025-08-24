import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FarmbrosLoader extends StatelessWidget {
  const FarmbrosLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset("assets/animations/farmbros_loader.json");
  }
}
