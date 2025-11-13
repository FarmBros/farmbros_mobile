import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_pininput.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController newPassword = TextEditingController();

    return Scaffold(
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: ColorUtils.primaryTextColor,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/background-two.png"))),
          child: Column(children: [
            Material(
              elevation: 0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(FluentIcons.ios_arrow_24_regular,
                          color: ColorUtils.primaryTextColor),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorUtils.primaryTextColor),
                    child: Column(
                      spacing: 15,
                      children: [
                        Text(
                          "Reset your Password",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              fontFamily: "Poppins"),
                        ),
                        Text(
                          "Use the OTP sent to your email  to reset your password",
                          style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
                        ),
                        FarmbrosPininput(),
                        FarmbrosInput(
                          controller: newPassword,
                          label: "New Password",
                          icon: FluentIcons.key_32_regular,
                          isPassword: true,
                          isTextArea: false,
                        ),
                        FarmbrosButton(
                            label: "Reset Password",
                            onPressed: () {},
                            buttonColor: ColorUtils.secondaryColor,
                            textColor: ColorUtils.primaryTextColor,
                            fontWeight: FontWeight.bold,
                            elevation: 4)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ])),
    );
  }
}
