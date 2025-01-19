import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/cubits/daily_streak/daily_streak_cubit.dart';
import 'package:task_groove/cubits/goal_celebration/goal_celebration_cubit.dart';
import 'package:task_groove/cubits/profile/profile_cubit.dart';
import 'package:task_groove/cubits/profile/profile_state.dart';
import 'package:task_groove/cubits/task_progress/task_progress_cubit.dart';
import 'package:task_groove/presentation/home/widgets/home_lists_widget.dart';
import 'package:task_groove/presentation/home/widgets/home_recent_activity.dart';
import 'package:task_groove/presentation/profile/statistics/edit_goals/goal_bottom_sheet.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
// import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/capitalize_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool _loadwithProgress = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserProfile(); // Load profile on init
    context.read<ProfileCubit>().trackLogin();
    context.read<DailyStreakCubit>().fetchStreakData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoalCelebrationCubit, GoalCelebrationState>(
      listener: (context, state) {
        if (state.triggerCelebration) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) => const FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.6,
              child: GoalBottomSheet(),
            ),
          );
        }
      },
      child: SafeArea(
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
                            BlocBuilder<DailyStreakCubit, DailyStreakState>(
                              builder: (context, state) {
                                final currentStreak = state.currentStreak;
                                return Text(
                                  "Day $currentStreak🔥",
                                  style: AppTextStyles.bodyTextBold,
                                );
                              },
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.15), // Lighter shadow
                                    blurRadius: 20, // Softer blur
                                    spreadRadius: 5, // Subtle expansion
                                    offset: const Offset(
                                        4, 4), // Slight offset for depth
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.05), // Lighter shadow for more depth
                                    blurRadius:
                                        30, // Larger blur for a more diffused effect
                                    spreadRadius:
                                        0, // No spread, keeps the inner shadow focused
                                    offset: const Offset(-4,
                                        -4), // Reverse offset to simulate light from a different angle
                                  ),
                                ],
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
                                    style: AppTextStyles.textWhite.copyWith(
                                      color: state.color == Colors.yellow
                                          ? Colors.black
                                          : Colors.white,
                                    ),
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
                                                textStyle: TextStyle(
                                              fontSize: 8.sp,
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
                    SizedBox(
                      height: 8.h,
                    ),
                    // ButtonPress(
                    //   text: "Logout",
                    //   loadWithProgress: _loadwithProgress,
                    //   onPressed: _logout,
                    // )
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
      ),
    );
  }
}
