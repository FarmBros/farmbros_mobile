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
  final bool isTextArea;
  final bool isDropDownField;
  final IconData? suffixIcon;
  final List<String>? dropDownItems;
  final ValueNotifier<String?>? dropdownController;
  final String? dropdownHint;
  final Function(String?)? onDropdownChanged;

  const FarmbrosInput({
    super.key,
    required this.label,
    required this.icon,
    required this.isPassword,
    required this.controller,
    this.isTextArea = false,
    this.isDropDownField = false,
    this.suffixIcon,
    this.dropDownItems,
    this.dropdownController,
    this.dropdownHint,
    this.onDropdownChanged,
  }) : assert(
          !isDropDownField ||
              (dropDownItems != null && dropdownController != null),
          'dropDownItems and dropdownController are required when isDropDownField is true',
        );

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

        // Render dropdown if isDropDownField is true
        if (isDropDownField) {
          return SizedBox(
            width: double.infinity,
            child: ValueListenableBuilder<String?>(
              valueListenable: dropdownController!,
              builder: (context, selectedValue, child) {
                return DropdownButtonFormField<String>(
                  value: selectedValue,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: fillColor,
                    labelText: label,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: isEnabled
                          ? ColorUtils.secondaryTextColor
                          : Colors.grey,
                    ),
                    prefixIcon: Icon(icon, color: iconColor),
                    suffixIcon: suffixIcon != null
                        ? Icon(suffixIcon, color: iconColor)
                        : null,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: state is FormErrorState && selectedValue == null
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
                  hint: dropdownHint != null ? Text(dropdownHint!) : null,
                  items: dropDownItems!.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: isEnabled
                      ? (String? newValue) {
                          dropdownController!.value = newValue;
                          if (onDropdownChanged != null) {
                            onDropdownChanged!(newValue);
                          }
                        }
                      : null,
                );
              },
            ),
          );
        }

        // Render regular TextField
        return SizedBox(
          width: double.infinity,
          child: TextField(
            controller: controller,
            enabled: isEnabled,
            obscureText: isPassword,
            maxLines: isTextArea ? 3 : 1,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              filled: true,
              fillColor: fillColor,
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 14,
                color: isEnabled ? ColorUtils.secondaryTextColor : Colors.grey,
              ),
              prefixIcon: Icon(icon, color: iconColor),
              suffixIcon: isPassword
                  ? Icon(Icons.visibility, color: iconColor)
                  : (suffixIcon != null
                      ? Icon(suffixIcon, color: iconColor)
                      : null),
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
