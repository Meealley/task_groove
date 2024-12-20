import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/daily_streak/daily_streak_cubit.dart';
import 'package:task_groove/cubits/profile/profile_cubit.dart';
import 'package:task_groove/cubits/profile/profile_state.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/presentation/profile/widgets/profile_lists.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';

import 'package:task_groove/models/user_model.dart';
import 'package:task_groove/utils/button.dart'; // Make sure to import the UserModel

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadwithProgress = false;

  void _logout() {
    setState(() {
      _loadwithProgress = !_loadwithProgress;
      Future.delayed(const Duration(seconds: 3), () {
        context.read<SignupCubit>().signOut(context);
        context.read<DailyStreakCubit>().reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    // Create a UserModel object from state
                    final user = UserModel(
                      userID: state.userID,
                      name: state.name,
                      email: state.email,
                      profilePicsUrl: state.profileImageUrl,
                      loginStreak: state.loginStreak,
                      points: state.points,
                      lastUsage: DateTime.now(),
                    );

                    // Pass the UserModel to the next screen
                    context.push(
                      Pages.profileDescription,
                      extra: user, // Pass the UserModel instance
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          state.profileImageUrl,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.name, // Username fetched from backend
                            style: AppTextStyles.headingBold,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.email, // Email fetched from backend
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 3.h,
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const ProfileList()),
            SizedBox(
              height: 3.h,
            ),
            ButtonPress(
              text: "Logout",
              loadWithProgress: _loadwithProgress,
              onPressed: _logout,
            )
          ],
        ),
      ),
    );
  }
}
