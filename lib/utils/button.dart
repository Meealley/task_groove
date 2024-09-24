import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class ButtonPress extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Function()? onPressed;
  const ButtonPress(
      {super.key, this.onPressed, required this.text, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: Container(
          decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.backgroundDark,
              borderRadius: const BorderRadius.all(
                Radius.circular(7),
              )),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.buttonTextWhite,
            ),
          ),
        ),
      ),
    );
  }
}
