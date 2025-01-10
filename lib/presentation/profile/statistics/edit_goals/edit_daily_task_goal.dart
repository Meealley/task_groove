import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_groove/cubits/daily_goals/daily_goals_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class EditDailyTaskGoal extends StatefulWidget {
  const EditDailyTaskGoal({
    super.key,
  });

  @override
  State<EditDailyTaskGoal> createState() => _EditDailyTaskGoalState();
}

class _EditDailyTaskGoalState extends State<EditDailyTaskGoal> {
  final TextEditingController _dailyTaskController = TextEditingController();

  @override
  void dispose() {
    _dailyTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "Daily Task Goals",
            style: AppTextStyles.bodyText,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: BlocBuilder<DailyGoalsCubit, DailyGoalsState>(
            builder: (context, state) {
              final totalTasks = state.totalTasks;
              return TextField(
                style: AppTextStyles.bodyText,
                keyboardType: TextInputType.number,
                controller: _dailyTaskController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "$totalTasks",
                  hintStyle: AppTextStyles.bodyText.copyWith(fontSize: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                onSubmitted: (value) {
                  final totalTasks = int.tryParse(value) ?? 0;
                  context.read<DailyGoalsCubit>().udpateTotalTasks(totalTasks);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
