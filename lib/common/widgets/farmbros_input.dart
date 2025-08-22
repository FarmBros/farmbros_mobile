import 'package:farmbros_mobile/common/bloc/form/combined_form_cubit.dart';
import 'package:farmbros_mobile/common/bloc/form/comnined_form_state.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FarmbrosInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  const FarmbrosInput({
    super.key,
    required this.label,
    required this.icon,
    required this.isPassword,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CombinedFormCubit, CombinedFormState>(
      builder: (context, state) {
        // Base styles
        Color borderColor = ColorUtils.primaryColor;
        Color? fillColor = ColorUtils.primaryTextColor;
        Color iconColor = ColorUtils.secondaryColor;

        bool isEnabled = true;

        if (state is FormLoadingState) {
          borderColor = Colors.grey;
          fillColor = Colors.grey[100];
          iconColor = Colors.grey;
          isEnabled = false;
        } else if (state is FormErrorState) {
          borderColor = ColorUtils.failureColor;
          iconColor = ColorUtils.failureColor;
        }

        return SizedBox(
          width: double.infinity,
          child: TextField(
            controller: controller,
            enabled: isEnabled,
            obscureText: isPassword,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 14,
                color: isEnabled ? ColorUtils.secondaryTextColor : Colors.grey,
              ),
              prefixIcon: Icon(icon, color: iconColor),
              suffixIcon:
                  isPassword ? Icon(Icons.visibility, color: iconColor) : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: state is FormErrorState && controller.text.isEmpty
                      ? ColorUtils.failureColor
                      : ColorUtils.secondaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorUtils.failureColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorUtils.failureColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}
