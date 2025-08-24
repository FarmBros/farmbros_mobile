import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FarmbrosLoader extends StatelessWidget {
  const FarmbrosLoader({super.key});

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
          Text(
            "Loading . . .",
            style: TextStyle(
                fontFamily: "Poppins",
                decoration: TextDecoration.none,
                color: ColorUtils.splashScreenBackground,
                fontSize: 18),
          ),
          Lottie.asset("assets/animations/farmbros_loader.json"),
          Image(
              height: 75,
              width: 75,
              image:
                  AssetImage("assets/images/farmbros-logo-green-outline.png")),
        ],
      ),
    );
  }
}
