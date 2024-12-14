import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class WeeklyGoals extends StatelessWidget {
  const WeeklyGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Streaks',
            style: AppTextStyles.bodyGrey,
          ),
          SizedBox(
            height: .3.h,
          ),
          Text(
            '1 day 🔥',
            style: AppTextStyles.bodyText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Longest: 4 days (12 Dec 2024 - 20 Dec 2024)',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }
}
