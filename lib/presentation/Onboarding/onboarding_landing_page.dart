import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';

class OnboardingLandingPage extends StatelessWidget {
  const OnboardingLandingPage({super.key});

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
                      "Onboarding",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorUtils.primaryTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 24),
                    ),
                    Text(
                      "Next Up: Set Up Your Farm",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorUtils.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "You're about to bring your farm to life, one detail at a time. "
                      "It’s a bit of a journey — but once complete, you'll see your "
                      "entire farm clearly, right in the palm of your hand.",
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
                    label: "Continue",
                    onPressed: () {},
                    buttonColor: ColorUtils.primaryTextColor,
                    textColor: ColorUtils.secondaryColor,
                    elevation: 4,
                    fontWeight: FontWeight.bold,
                  ),
                  FarmbrosButton(
                    label: "Skip",
                    onPressed: () {},
                    buttonColor: ColorUtils.transparent,
                    textColor: ColorUtils.secondaryTextColor,
                    elevation: 0,
                    textDecoration: TextDecoration.underline,
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
