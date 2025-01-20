import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/theme/appcolors.dart';
// import 'package:todo_cube/utils/appcolors.dart';

class AppTextStyles {
  static final TextStyle headingBold = GoogleFonts.manrope(
    textStyle: TextStyle(
      color: AppColors.textSecondary,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    ),
  );
  static final TextStyle heading = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 23.sp,
    ),
  );
  static final TextStyle bodyText = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 10.3.sp,
      color: Colors.black,
    ),
  );
  static final TextStyle bodyTextLg = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 12.sp,
      color: Colors.black,
    ),
  );
  static final TextStyle bodyGrey = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 10.sp,
      color: const Color.fromARGB(255, 136, 134, 134),
    ),
  );
  static final TextStyle bodyTextBold = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.bold,
    ),
  );
  static final TextStyle bodySmall = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 10.sp,
    ),
  );
  static final TextStyle bodyItems = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 14.sp,
      color: Colors.red,
    ),
  );
  static final TextStyle bodySmallUnderline = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 10.sp,
      color: AppColors.primary,
      decoration: TextDecoration.underline,
    ),
  );
  static final TextStyle textWhite = GoogleFonts.manrope(
    textStyle: TextStyle(
      fontSize: 10.5.sp,
      color: AppColors.textWhite,
      // decoration: TextDecoration.underline,
    ),
  );
  static final TextStyle buttonTextWhite = GoogleFonts.manrope(
    textStyle: TextStyle(fontSize: 16.sp, color: AppColors.textWhite),
  );
  static final TextStyle errorTextMessage = GoogleFonts.manrope(
    textStyle: TextStyle(fontSize: 9.sp, color: AppColors.errorText),
  );
}
