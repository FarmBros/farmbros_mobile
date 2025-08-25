import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FarmbrosLoader extends StatefulWidget {
  const FarmbrosLoader({super.key});

  @override
  State<FarmbrosLoader> createState() => _FarmbrosLoaderState();
}

class _FarmbrosLoaderState extends State<FarmbrosLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorUtils.lightBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _animation,
            child: const Text(
              "Loading . . .",
              style: TextStyle(
                fontFamily: "Poppins",
                decoration: TextDecoration.none,
                color: ColorUtils.splashScreenBackground,
                fontSize: 18,
              ),
            ),
          ),
          Lottie.asset("assets/animations/farmbros_loader.json"),
          FadeTransition(
            opacity: _animation,
            child: Image.asset(
              "assets/images/farm_bros_icon.png",
              height: 75,
              width: 75,
            ),
          ),
        ],
      ),
    );
  }
}
