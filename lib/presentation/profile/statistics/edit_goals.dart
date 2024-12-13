import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class EditGoals extends StatelessWidget {
  const EditGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Edit Goals",
            style: AppTextStyles.bodyText,
          )
        ],
      ),
    );
  }
}

// TODO : WORK ON THE EDIT_GOAL

