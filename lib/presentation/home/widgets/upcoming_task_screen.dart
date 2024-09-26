import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class UpcomingTaskScreen extends StatefulWidget {
  const UpcomingTaskScreen({super.key});

  @override
  State<UpcomingTaskScreen> createState() => _UpcomingTaskScreenState();
}

class _UpcomingTaskScreenState extends State<UpcomingTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upcoming",
          style: AppTextStyles.bodyText,
        ),
      ),
      body: Center(
        child: Text(
          "Upcoming Task Page",
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }
}
