import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmbros_mobile/common/bloc/form/comnined_form_state.dart';
import 'package:farmbros_mobile/common/bloc/form/combined_form_cubit.dart';

class FarmbrosButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final double? elevation;
  final TextDecoration? textDecoration;
  final FontWeight? fontWeight;
  final IconData? icon;
  final Color? iconColor;

  const FarmbrosButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.buttonColor,
      this.textColor,
      this.elevation,
      this.textDecoration,
      this.fontWeight,
      this.icon,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CombinedFormCubit, CombinedFormState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStatePropertyAll(elevation ?? 2),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(state is FormErrorState
                  ? ColorUtils.failureColor
                  : buttonColor),
            ),
            onPressed: state is FormLoadingState ? null : onPressed,
            child: _buildChild(state),
          ),
        );
      },
    );
  }

  Widget _buildChild(CombinedFormState state) {
    if (state is FormLoadingState) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );
    } else if (state is FormSuccessState) {
      return const Icon(FluentIcons.check_24_filled, color: Colors.white);
    } else if (state is FormErrorState) {
      return const Icon(FluentIcons.dismiss_24_filled, color: Colors.white);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: iconColor,
            ),
          Text(
            label,
            style: TextStyle(
              color: textColor ?? Colors.white,
              decoration: textDecoration,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
        ],
      );
    }
  }
}
