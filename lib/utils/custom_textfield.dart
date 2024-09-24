// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final String? errorText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  const CustomTextField({
    super.key,
    this.labelText,
    this.validator,
    this.onSaved,
    this.errorText,
    required this.textInputType,
    required this.textEditingController,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: textEditingController,
      style: obscureText ? AppTextStyles.heading : AppTextStyles.bodySmall,
      validator: validator,
      onSaved: onSaved,
      cursorHeight: 23,
      obscureText: obscureText,
      decoration: InputDecoration(
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
            Radius.circular(
              10,
            ),
          ),
          borderSide: BorderSide(
            color: AppColors.backgroundDark,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
          borderSide: BorderSide(
            color: AppColors.backgroundDark,
          ),
        ),
      ),
    );
  }
}
