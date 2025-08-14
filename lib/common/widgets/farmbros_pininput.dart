import 'package:farmbros_mobile/common/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class FarmbrosPininput extends StatelessWidget {
  const FarmbrosPininput({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtils.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter One Time Pin (OTP)",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Pinput(
          length: 6,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              border: Border.all(color: ColorUtils.primaryColor, width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          preFilledWidget: Text(
            '-',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade400,
            ),
          ),
        )
      ],
    );
  }
}
