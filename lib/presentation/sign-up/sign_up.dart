// import 'package:farmbros_mobile/apis/auth_api.dart';
import 'package:farmbros_mobile/common/bloc/button/button_state.dart';
import 'package:farmbros_mobile/common/bloc/button/button_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_notification_banner.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/data/models/sign_up_req_params.dart';
import 'package:farmbros_mobile/domain/usecases/sign_up_use_case.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TapGestureRecognizer _tapGestureRecognizer;
  final TextEditingController username = TextEditingController();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController password = TextEditingController();

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
    context.go("/sign_in");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
        builder: (context, state) {
      return Scaffold(
          body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40),
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              height: MediaQuery.of(context).size.height * 0.70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: ColorUtils.primaryTextColor,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/sign_up_bg.png")),
              ),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 15,
                  children: [
                    Text(
                      "Create your Account",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FarmbrosInput(
                      controller: email,
                      label: "Email Address",
                      icon: FluentIcons.mail_48_regular,
                      isPassword: false,
                    ),
                    FarmbrosInput(
                      controller: firstname,
                      label: "firstname",
                      icon: FluentIcons.person_48_regular,
                      isPassword: false,
                    ),
                    FarmbrosInput(
                      controller: lastname,
                      label: "lastname",
                      icon: FluentIcons.person_48_regular,
                      isPassword: false,
                    ),
                    FarmbrosInput(
                      controller: username,
                      label: "Username",
                      icon: FluentIcons.person_48_regular,
                      isPassword: false,
                    ),
                    FarmbrosInput(
                      controller: phoneNumber,
                      label: "Phone Number",
                      icon: FluentIcons.call_48_regular,
                      isPassword: false,
                    ),
                    FarmbrosInput(
                      controller: password,
                      label: "Password",
                      icon: FluentIcons.key_32_regular,
                      isPassword: true,
                    ),
                    FarmbrosButton(
                      label: state is ButtonLoadingState
                          ? "Creating Account..."
                          : "Sign Up",
                      buttonColor: ColorUtils.secondaryColor,
                      textColor: ColorUtils.primaryTextColor,
                      fontWeight: FontWeight.bold,
                      onPressed: state is ButtonLoadingState
                          ? null
                          : () {
                              // Basic validation
                              if (username.text.isEmpty ||
                                  email.text.isEmpty ||
                                  password.text.isEmpty ||
                                  firstname.text.isEmpty ||
                                  lastname.text.isEmpty ||
                                  phoneNumber.text.isEmpty) {
                                // You could show a snackbar or validation message here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Please fill in all fields")),
                                );
                                return;
                              }

                              final signUpParams = SignUpReqParams(
                                username: username.text.trim(),
                                firstName: firstname.text.trim(),
                                lastName: lastname.text.trim(),
                                fullName:
                                    "${firstname.text.trim()} ${lastname.text.trim()}",
                                email: email.text.trim().toLowerCase(),
                                phoneNumber: phoneNumber.text.trim(),
                                password: password.text,
                              );

                              context.read<ButtonStateCubit>().execute(
                                    signUpParams,
                                    sl<SignUpUseCase>(),
                                  );
                            },
                      elevation: 4,
                    ),
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
                        text: "Already have an account? ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                              text: "Sign In",
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
            ),
          ),
          Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: state is ButtonFailureState
                  ? FarmbrosNotificationBanner(
                      message: state.errorMessage,
                      color: ColorUtils.failureColor)
                  : state is ButtonSuccessState
                      ? FarmbrosNotificationBanner(
                          message: "Account Created Succesfully",
                          color: ColorUtils.successColor)
                      : SizedBox.shrink())
        ],
      ));
    });
  }
}
