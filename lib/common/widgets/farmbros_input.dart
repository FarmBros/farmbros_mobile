import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';

class FarmbrosInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  const FarmbrosInput(
      {super.key,
      required this.label,
      required this.icon,
      required this.isPassword,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              fontSize: 14, color: ColorUtils.secondaryTextColor),
          prefixIcon: Icon(
            icon,
            color: ColorUtils.secondaryColor,
          ),
          suffixIcon: isPassword ? const Icon(Icons.visibility) : null,

          // Outline border always visible
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.secondaryColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
