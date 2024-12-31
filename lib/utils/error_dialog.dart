import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/custom_error.dart';

void errorDialog(BuildContext context, CustomError e) {
  // Extract the message to display
  final errorMessage = e.userMessage;

  print('code: ${e.code}\nmessage: ${e.message}\nplugin: ${e.plugin}\n');

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Error", // Display a generic title
            style: AppTextStyles.bodyText,
          ),
          content: Text(
            errorMessage,
            style: AppTextStyles.bodySmall,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                "OK",
                style: AppTextStyles.bodySmall,
              ),
              onPressed: () => context.pop(),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Error", // Display a generic title
            style: AppTextStyles.bodyText,
          ),
          content: Text(
            errorMessage,
            style: AppTextStyles.bodySmall,
          ),
          actions: [
            ButtonPress(
              loadWithProgress: false,
              text: "OK",
              onPressed: () => context.pop(),
            ),
          ],
        );
      },
    );
  }
}
