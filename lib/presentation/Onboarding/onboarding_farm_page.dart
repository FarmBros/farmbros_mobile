import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class OnboardingFarmPage extends StatelessWidget {
  const OnboardingFarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController farmname = TextEditingController();

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
                      "Step 1: Define Your Farm",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorUtils.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "Begin by entering your farm's key details — location, size, and type. "
                      "This information helps us generate a personalized digital version of "
                      "your farm, laying the foundation for everything else to follow.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorUtils.secondaryTextColor, fontSize: 14),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  spacing: 20,
                  children: [
                    FarmbrosInput(
                        label: "Farm name",
                        icon: FluentIcons.certificate_24_regular,
                        isPassword: false,
                        controller: farmname),
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sketch Farm Dimensions",
                          style:
                              TextStyle(color: ColorUtils.secondaryTextColor),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 2.75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorUtils.secondaryBackgroundColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  FarmbrosButton(
                    label: "Save Farm Details",
                    onPressed: () {},
                    buttonColor: ColorUtils.primaryTextColor,
                    textColor: ColorUtils.secondaryColor,
                    elevation: 4,
                    fontWeight: FontWeight.bold,
                  ),
                  //  FarmbrosButton(
                  //     label: "Skip",
                  //     onPressed: () {},
                  //     buttonColor: ColorUtils.transparent,
                  //     textColor: ColorUtils.secondaryTextColor,
                  //     elevation: 0,
                  //     textDecoration: TextDecoration.underline,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
