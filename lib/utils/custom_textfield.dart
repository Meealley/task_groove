import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? errorText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final bool obscureText; // Add this for password visibility control
  final Widget? suffixIcon; // Add this for the visibility toggle button
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    this.labelText,
    this.validator,
    this.onSaved,
    this.errorText,
    required this.textInputType,
    required this.textEditingController,
    this.obscureText = false, // Default value is false for non-password fields
    this.suffixIcon,
    this.prefixIcon, // Optional, used for visibility toggle
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: textEditingController,
      style:
          obscureText ? const TextStyle(fontSize: 27) : AppTextStyles.bodySmall,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText, // Use the passed obscureText value
      cursorHeight: obscureText ? 27 : 23,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        errorText: errorText,
        errorStyle: AppTextStyles.errorTextMessage,
        labelText: labelText,
        labelStyle: AppTextStyles.bodyText,
        contentPadding: const EdgeInsets.only(
          top: 1,
          bottom: 0,
          left: 6,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: AppColors.backgroundDark,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: AppColors.backgroundDark,
          ),
        ),
        suffixIcon: suffixIcon, // Set the suffix icon for toggling visibility
      ),
    );
  }
}
