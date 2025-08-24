import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FarmbrosLoader extends StatelessWidget {
  const FarmbrosLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Loading . . .",
          style: TextStyle(
              fontFamily: "Poppins",
              decoration: TextDecoration.none,
              color: ColorUtils.secondaryTextColor,
              fontSize: 18),
        ),
        Lottie.asset("assets/animations/farmbros_loader.json"),
        Image(
            height: 100,
            width: 100,
            image: AssetImage("assets/images/farmbros-logo-white-outline.png")),
      ],
    );
  }
}
