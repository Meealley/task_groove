import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/weekly_goals/weekly_goals_cubit.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class WeeklyGoals extends StatefulWidget {
  const WeeklyGoals({super.key});

  @override
  State<WeeklyGoals> createState() => _WeeklyGoalsState();
}

class _WeeklyGoalsState extends State<WeeklyGoals> {
  String _getCongratulatoryMessage(int completedTasks, int totalTasks) {
    if (completedTasks == totalTasks && totalTasks > 0) {
      return 'You Rocked hard this week!';
    } else if (completedTasks > 0) {
      return 'You\'re off to a great week!';
    } else if (totalTasks == 0) {
      return 'No tasks for today. Let\'s add some';
    } else {
      return 'Start your day strong! You can do it';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyGoalsCubit, WeeklyGoalsState>(
      builder: (context, state) {
        final totalTasks = state.totalTasks;
        final completedTasks = state.completedTask;

        // For congratulatory message
        final motivationalMessage =
            _getCongratulatoryMessage(completedTasks, totalTasks);
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Goals',
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
                        "$completedTasks/$totalTasks tasks",
                        style: AppTextStyles.bodyText,
                      ),
                      SizedBox(
                        height: .3.h,
                      ),
                      Text(
                        motivationalMessage,
                        style: AppTextStyles.bodySmall,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      GestureDetector(
                        onTap: () => context.push(Pages.editGoals),
                        child: Text(
                          "Edit Goals",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.backgroundDark,
                          ),
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
                          percent: totalTasks > 0
                              ? (completedTasks / totalTasks).clamp(0.0, 1.0)
                              : 0.0,
                          // percent: .7,
                          radius: 40,
                          center: FaIcon(
                            FontAwesomeIcons.trophy,
                            color: completedTasks / totalTasks == 1
                                ? Colors.green
                                : Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        );
      },
    );
  }
}
