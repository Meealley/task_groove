import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class EditWeeklyTaskGoal extends StatefulWidget {
  const EditWeeklyTaskGoal({
    super.key,
  });

  @override
  State<EditWeeklyTaskGoal> createState() => _EditWeeklyTaskGoalState();
}

class _EditWeeklyTaskGoalState extends State<EditWeeklyTaskGoal> {
  final TextEditingController _weeklyTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "Weekly Task Goals",
            style: AppTextStyles.bodyText,
          ),
        ),
        const SizedBox(width: 10), // Adds spacing between text and field
        SizedBox(
          width: 100, // Fixed width for the TextField
          child: TextField(
            style: AppTextStyles.bodyText,
            keyboardType: TextInputType.number,
            controller: _weeklyTaskController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none, // Removes the bottom border
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0), // Adjust padding
            ),
          ),
        ),
      ],
    );
  }
}
