import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
                height: 3.h,
              ),
              SizedBox(
                height: 20.h,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -70,
                        left: 0,
                        child: Image.asset(
                          "assets/images/home_productive.png",
                          width: 160,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: -70,
                        child: Image.asset(
                          "assets/images/spiralcurvearrow.png",
                          width: 200,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 60,
                        right: 70,
                        child: Text(
                          "Manage and Organise\n your tasks",
                          style: AppTextStyles.textWhite,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearPercentIndicator(
                            width: 220,
                            lineHeight: 17,
                            barRadius: const Radius.circular(10),
                            // fillColor: Colors.yellow,
                            backgroundColor: Colors.white,
                            animation: true,

                            animationDuration: 2000,
                            percent: 0.5,
                            center: Text(
                              "90.0%",
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                            // linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.greenAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
