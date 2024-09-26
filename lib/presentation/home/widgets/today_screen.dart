import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({super.key});

  @override
  State<TodayTaskScreen> createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today Task",
          style: AppTextStyles.bodyText,
        ),
      ),
      body: Center(
        child: Text(
          "Today Task Page",
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }
}
