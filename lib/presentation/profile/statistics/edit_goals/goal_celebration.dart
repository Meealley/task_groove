import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class GoalCelebration extends StatefulWidget {
  const GoalCelebration({super.key});

  @override
  State<GoalCelebration> createState() => _GoalCelebrationState();
}

class _GoalCelebrationState extends State<GoalCelebration> {
  bool isCelebrationEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.grey.shade400, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Goal Celebration", style: AppTextStyles.bodyText),
          GestureDetector(
            onTap: () {
              setState(() {
                isCelebrationEnabled = !isCelebrationEnabled;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isCelebrationEnabled ? Colors.green : Colors.grey,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isCelebrationEnabled
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 26,
                  height: 26,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
