import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/presentation/profile/statistics/edit_goals/edit_daily_task_goal.dart';
import 'package:task_groove/presentation/profile/statistics/edit_goals/edit_weekly_task_goal.dart';
import 'package:task_groove/presentation/profile/statistics/edit_goals/goal_celebration.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/capitalize_text.dart';

class EditGoals extends StatefulWidget {
  const EditGoals({super.key});

  @override
  State<EditGoals> createState() => _EditGoalsState();
}

class _EditGoalsState extends State<EditGoals> {
  // bool isCelebrationEnabled = false;

  // void _toggleCelebration(bool isEnabled) {
  //   setState(() {
  //     isCelebrationEnabled = isEnabled;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Text(
              capitalizeAllTexts("i want to complete ..."),
              style: AppTextStyles.bodyText,
            ),
            SizedBox(
              height: 3.h,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12)),
              child: const Column(
                children: [
                  EditDailyTaskGoal(),
                  Divider(
                    color: Colors.black,
                  ),
                  EditWeeklyTaskGoal(),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            const GoalCelebration(),
            SizedBox(
              height: .5.h,
            ),
            Text(
              "Celebrate reaching your daily and weekly task goals",
              style: AppTextStyles.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
