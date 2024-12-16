import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/daily_goals/daily_goals_cubit.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class DailyGoals extends StatefulWidget {
  const DailyGoals({super.key});

  @override
  State<DailyGoals> createState() => _DailyGoalsState();
}

class _DailyGoalsState extends State<DailyGoals> {
  // TODO : MAKE THE MESSAGE SENT TO THE USER DYNAMIC, SUCH THAT, THE GET A CONGRATULATORY MESSAGE WHEN THE COMPLETE THEIR TOTAL GOALS FOR THE DAY

  String _getCongratulatoryMessage(int completedTasks, int totalTasks) {
    if (completedTasks == totalTasks && totalTasks > 0) {
      return 'Mischief managed, Well done!';
    } else if (completedTasks > 0) {
      return 'You\'ve got some great momentum!';
    } else if (totalTasks == 0) {
      return 'No tasks for today. Let\'s add some';
    } else {
      return 'Start your day strong! You can do it';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyGoalsCubit, DailyGoalsState>(
      builder: (context, state) {
        final totalTasks = state.totalTasks;
        final completedTasks = state.completedTasks;

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
                        '$completedTasks/$totalTasks tasks',
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
                              ? completedTasks / totalTasks
                              : 0.0,
                          // percent: .7,
                          radius: 40,
                          center: FaIcon(
                            FontAwesomeIcons.medal,
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
              )
            ],
          ),
        );
      },
    );
  }
}
