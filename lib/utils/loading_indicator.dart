import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class LoadingBtnIndicator extends StatelessWidget {
  const LoadingBtnIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 2.h,
          child: const CircularProgressIndicator(
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
    );
  }
}
