// import 'package:farmbros_mobile/apis/auth_api.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/data/models/sign_in_req_params.dart';
import 'package:farmbros_mobile/domain/usecases/sign_in_use_case.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late TapGestureRecognizer _tapGestureRecognizer;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handlePress;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _handlePress() {
    HapticFeedback.vibrate();
    context.go("/sign_up");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 80),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/background-two.png"))),
            child: Column(
              children: [
                Image(
                    height: 200,
                    width: 200,
                    image: AssetImage("assets/images/farmbros-logo.png"))
              ],
            )),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: ColorUtils.primaryTextColor,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/login_bg.png")),
                ),
                child: Column(
                  spacing: 15,
                  children: [
                    Text(
                      "Welcome back, login to continue",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FarmbrosInput(
                      label: "Username or email address",
                      controller: username,
                      icon: FluentIcons.mail_48_regular,
                      isPassword: false,
                    ),
                    FarmbrosInput(
                      label: "Password",
                      controller: password,
                      icon: FluentIcons.key_32_regular,
                      isPassword: true,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          context.go("/forgot_password");
                        },
                        child: Text(
                          "Forgot Password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: ColorUtils.secondaryTextColor),
                        ),
                      ),
                    ),
                    FarmbrosButton(
                        label: "Login",
                        buttonColor: ColorUtils.secondaryColor,
                        textColor: ColorUtils.primaryTextColor,
                        fontWeight: FontWeight.bold,
                        onPressed: () {
                          sl<SignInUseCase>().call(
                              param: SignInReqParams(
                                  username: username.text,
                                  password: password.text));
                        },
                        elevation: 4),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Divider(
                          color: ColorUtils.secondaryTextColor,
                        ),
                        Positioned(
                            left: 100,
                            right: 100,
                            bottom: -5,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: ColorUtils.primaryTextColor),
                              child: Text(
                                textAlign: TextAlign.center,
                                "or continue with",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: Image(
                        image: AssetImage("assets/images/google_logo.png"),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Do not have an account? ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                              text: "Sign Up",
                              style: const TextStyle(
                                color: Colors.blue, // link color
                                decoration:
                                    TextDecoration.underline, // underline link
                              ),
                              recognizer: _tapGestureRecognizer),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ))
      ],
    ));
  }
}
