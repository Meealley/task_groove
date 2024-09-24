import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Screen",
          style: AppTextStyles.bodyTextBold,
        ),
      ),
      body: Column(
        children: [
          Text(
            "This is the home screen",
            style: AppTextStyles.bodyText,
          ),
          SizedBox(
            height: 8.h,
          ),
          ButtonPress(
            text: "Logout",
            onPressed: () {
              context.read<SignupCubit>().signOut(context);
            },
          )
        ],
      ),
    );
  }
}
