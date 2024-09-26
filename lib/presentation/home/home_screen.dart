import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loadwithProgress = false;

  void _logout() {
    setState(() {
      _loadwithProgress = !_loadwithProgress;
      Future.delayed(const Duration(seconds: 3), () {
        context.read<SignupCubit>().signOut(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Welcome Back User",
                    style: AppTextStyles.bodyTextBold,
                  ),
                  Text(
                    "Day 1, Thursday",
                    style: AppTextStyles.bodyGrey,
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              ButtonPress(
                text: "Logout",
                loadWithProgress: _loadwithProgress,
                onPressed: _logout,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.backgroundDark,
            shape: const CircleBorder(),
            child: const FaIcon(
              FontAwesomeIcons.plus,
              color: AppColors.textWhite,
            ),
            onPressed: () {}),
      ),
    );
  }
}
