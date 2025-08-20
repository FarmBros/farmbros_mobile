import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_pininput.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: ColorUtils.primaryTextColor,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/background-two.png"))),
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
                        "Confirm your Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            fontFamily: "Poppins"),
                      ),
                      Text(
                        "Use the OTP sent to your email  to confirm your email address",
                        style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
                      ),
                      FarmbrosPininput(),
                      Text(
                        "Request another code in: 0:45 Secs",
                        style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
                      ),
                      FarmbrosButton(
                          label: "Verify Email",
                          onPressed: () {},
                          buttonColor: ColorUtils.secondaryColor,
                          textColor: ColorUtils.primaryTextColor,
                          fontWeight: FontWeight.bold,
                          elevation: 4)
                    ],
                  ),
                )
              ])),
    );
  }
}
