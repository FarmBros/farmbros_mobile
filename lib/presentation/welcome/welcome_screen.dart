import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.primaryColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/background-one.png"))),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text("Welcome to a unique farming experience",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text("FarmBros is your smart companion for managing every "
                  "corner of your farm – from crops to livestock, tools to "
                  "structures – all in one beautifully intuitive platform. "
                  "Whether you're drawing your shamba or tracking your harvest, "
                  "FarmBros puts the power of your entire farm in your hands."),
              Image(image: AssetImage("assets/images/bros-illustration.png")),
              Column(
                children: [
                  FarmbrosButton(
                    label: "Sign Up",
                    onPressed: () {
                      context.go(Routes.signUp);
                    },
                    buttonColor: ColorUtils.primaryTextColor,
                    textColor: ColorUtils.secondaryColor,
                    elevation: 4,
                    fontWeight: FontWeight.bold,
                  ),
                  FarmbrosButton(
                    label: "Sign In",
                    onPressed: () {
                      context.go(Routes.signIn);
                    },
                    buttonColor: ColorUtils.transparent,
                    textColor: ColorUtils.secondaryTextColor,
                    elevation: 0,
                    textDecoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  )
                ],
              )
            ]),
      ),
    );
  }
}
