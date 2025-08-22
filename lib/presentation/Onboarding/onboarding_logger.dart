import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';

class OnboardingLogger extends StatelessWidget {
  const OnboardingLogger({super.key});

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
                      "Step 2: Log your animals and crops",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorUtils.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "Now it’s time to add the heart of your farm — your animals "
                      "and crops. We’ll guide you through logging each one, so you "
                      "can easily track, manage, and monitor every living asset on "
                      "your farm with confidence.",
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
