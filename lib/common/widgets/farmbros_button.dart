import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmbros_mobile/bloc/farmbros_button_bloc/button_bloc.dart';
import 'package:farmbros_mobile/bloc/farmbros_button_bloc/button_event.dart';
import 'package:farmbros_mobile/bloc/farmbros_button_bloc/button_state.dart';

class FarmbrosButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
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
    return BlocBuilder<ButtonBloc, ButtonState>(
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
            child: state.isLoading!
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
