// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Profile Page",
          style: AppTextStyles.bodyText,
        ),
      ),
    );
  }
}
