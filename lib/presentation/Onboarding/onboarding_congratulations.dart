import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';

class OnboardingCongratulations extends StatelessWidget {
  const OnboardingCongratulations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(right: 20, left: 20, top: 70, bottom: 40),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/background-one.png"))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 5),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            width: 10,
                            color: ColorUtils.secondaryBackgroundColor))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Congratulations!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorUtils.primaryTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 24),
                    ),
                    Text(
                      "Farm Setup Complete!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorUtils.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "Great job setting up your farm! It’s officially alive and thriving. "
                      "From here on, everything you grow, raise, or build will be tracked "
                      "right at your fingertips. Let’s keep growing! 🌱🚜",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorUtils.secondaryTextColor, fontSize: 14),
                    )
                  ],
                ),
              ),
              Image(
                  width: 250,
                  // height: 380,
                  image: AssetImage("assets/images/onboarding.png")),
              Column(
                children: [
                  FarmbrosButton(
                    label: "Finish",
                    onPressed: () {},
                    buttonColor: ColorUtils.primaryTextColor,
                    textColor: ColorUtils.secondaryColor,
                    elevation: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
