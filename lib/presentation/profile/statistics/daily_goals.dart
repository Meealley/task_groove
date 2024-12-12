import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class DailyGoals extends StatefulWidget {
  const DailyGoals({super.key});

  @override
  State<DailyGoals> createState() => _DailyGoalsState();
}

class _DailyGoalsState extends State<DailyGoals> {
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
            "Daily goals",
            style: AppTextStyles.bodyGrey,
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${5}/5 tasks',
                    style: AppTextStyles.bodyText,
                  ),
                  SizedBox(
                    height: .3.h,
                  ),
                  Text(
                    'Mischief managed. Well done!',
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "Edit Goals",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.backgroundDark,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 5.w,
              ),
              Stack(
                children: [
                  Positioned(
                    child: CircularPercentIndicator(
                      progressColor: Colors.green,
                      percent: .4,
                      radius: 40,
                      center: const FaIcon(
                        FontAwesomeIcons.medal,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}