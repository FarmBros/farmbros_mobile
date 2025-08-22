import 'package:farmbros_mobile/common/bloc/button/button_state.dart';
import 'package:farmbros_mobile/common/bloc/button/button_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FarmbrosButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final double? elevation;
  final TextDecoration? textDecoration;
  final FontWeight? fontWeight;

  const FarmbrosButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    required this.elevation,
    this.textDecoration,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStatePropertyAll(elevation),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(buttonColor),
            ),
            onPressed: onPressed,
            child: state is ButtonLoadingState
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                        color: textColor,
                        decoration: textDecoration,
                        fontWeight: fontWeight),
                  ),
          ),
        );
      },
    );
  }
}
