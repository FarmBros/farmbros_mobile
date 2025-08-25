import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class OnboardingFarmPage extends StatelessWidget {
  const OnboardingFarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController farmname = TextEditingController();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(right: 20, left: 20, top: 70, bottom: 40),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/background-one.png"))),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
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
                child: Column(
                  spacing: 20,
                  children: [
                    FarmbrosInput(
                        label: "Farm name",
                        icon: FluentIcons.certificate_24_regular,
                        isPassword: false,
                        isTextArea: false,
                        controller: farmname),
                    FarmbrosInput(
                      label: "Description",
                      icon: FluentIcons.certificate_24_regular,
                      isPassword: false,
                      controller: farmname,
                      isTextArea: true,
                    ),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: MapWidget(
                              key: ValueKey("mapbox-map"),
                            ),
                          ),
                          // child: Maps
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: FarmbrosButton(
                      label: "Draw",
                      onPressed: () => _handleNavigate(context),
                      buttonColor: ColorUtils.primaryTextColor,
                      textColor: ColorUtils.secondaryColor,
                      elevation: 4,
                      fontWeight: FontWeight.bold,
                      icon: CupertinoIcons.hand_draw,
                    ),
                  ),
                  Expanded(
                    child: FarmbrosButton(
                      label: "Clear",
                      onPressed: () {},
                      buttonColor: ColorUtils.successColor,
                      textColor: ColorUtils.primaryTextColor,
                      elevation: 4,
                      fontWeight: FontWeight.bold,
                      icon: CupertinoIcons.clear,
                      iconColor: ColorUtils.primaryTextColor,
                    ),
                  )
                ],
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigate(BuildContext context) {
    print(Routes.map);
    context.push(Routes.map);
  }
}
