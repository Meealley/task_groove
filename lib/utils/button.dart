import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class ButtonPress extends StatelessWidget {
  final String text;
  final bool? loadWithProgress;
  final Color? backgroundColor;
  final Function()? onPressed;
  const ButtonPress(
      {super.key,
      this.onPressed,
      this.loadWithProgress,
      required this.text,
      this.backgroundColor});

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
          child: loadWithProgress!
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centers children horizontally
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Centers children vertically
                    mainAxisSize: MainAxisSize
                        .min, // Ensures Row takes up only the necessary space
                    children: [
                      const SizedBox(
                        height: 13,
                        width: 13,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        "Loading...",
                        style: AppTextStyles.bodySmall,
                      )
                    ],
                  ),
                )
              : Center(
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
