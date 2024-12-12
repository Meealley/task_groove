import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/cubit/theme_cubit.dart';
import 'package:task_groove/cubits/profile/profile_cubit.dart';
import 'package:task_groove/cubits/profile/profile_state.dart';
import 'package:task_groove/cubits/task_progress/task_progress_cubit.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/presentation/home/widgets/home_lists_widget.dart';
import 'package:task_groove/presentation/home/widgets/home_recent_activity.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/capitalize_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loadwithProgress = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserProfile(); // Load profile on init
    context.read<ProfileCubit>().trackLogin(); // Track user login;
  }

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
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Welcome Back, ${capitalizeFirstLetter(state.name)}",
                            style: AppTextStyles.bodyTextBold,
                          ),
                          Text(
                            "Day ${state.loginStreak} 🔥",
                            style: AppTextStyles.bodyTextBold,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    height: 20.h,
                    width: double.infinity,
                    child: BlocBuilder<ThemeCubit, ThemeState>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                              color: state.color,
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
                                child: BlocBuilder<TaskProgressCubit,
                                    TaskProgressState>(
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LinearPercentIndicator(
                                        width: 220,
                                        lineHeight: 17,
                                        barRadius: const Radius.circular(10),
                                        // fillColor: Colors.yellow,
                                        backgroundColor: Colors.white,
                                        animation: true,

                                        animationDuration: 2000,
                                        percent: state.percentCompleted,
                                        center: Text(
                                          "${(state.percentCompleted * 100).toStringAsFixed(1)}%",
                                          style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          )),
                                        ),
                                        // linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: Colors.greenAccent,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  const HomeListWidgets(),
                  SizedBox(
                    height: 2.h,
                  ),

                  SizedBox(
                    height: 1.5.h,
                  ),
                  const HomeRecentActivity(),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     print("Track log in cliecked");
                  //     context.read<ProfileCubit>().trackLogin();
                  //   },
                  //   child: const Text('Track Login'),
                  // ),
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
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return FloatingActionButton(
                backgroundColor: state.color,
                shape: const CircleBorder(),
                child: const FaIcon(
                  FontAwesomeIcons.plus,
                  color: AppColors.textWhite,
                ),
                onPressed: () {
                  context.push(Pages.createTask);
                });
          },
        ),
      ),
    );
  }
}
