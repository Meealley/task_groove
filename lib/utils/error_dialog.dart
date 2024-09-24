import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/custom_error.dart';

void errorDialog(BuildContext context, CustomError e) {
  print('code : ${e.code}\n message : ${e.message}\n plugin : ${e.plugin}\n');

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (contex) {
        return CupertinoAlertDialog(
          title: Text(
            e.code,
            style: AppTextStyles.bodyText,
          ),
          content: Text(
            '${e.plugin}\n${e.message}',
            style: AppTextStyles.bodySmall,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                "Ok",
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
              e.code,
              style: AppTextStyles.bodyText,
            ),
            content: Text(
              '${e.plugin}\n${e.message}',
              style: AppTextStyles.bodySmall,
            ),
            actions: [
              ButtonPress(
                text: "OK",
                onPressed: () => context.pop(),
              )
            ],
          );
        });
  }
}
