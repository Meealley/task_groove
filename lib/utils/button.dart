import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';

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
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                  // color: backgroundColor ?? AppColors.backgroundDark,
                  color: state.color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(7),
                  )),
              child: loadWithProgress!
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
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
                            style: AppTextStyles.bodySmall.copyWith(
                              color: state.color == Colors.yellow
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        text,
                        style: AppTextStyles.bodyText.copyWith(
                          color: state.color == Colors.yellow
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
