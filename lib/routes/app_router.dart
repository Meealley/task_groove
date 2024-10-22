import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/models/user_model.dart';
import 'package:task_groove/presentation/add_tasks/create_task_screen.dart';
import 'package:task_groove/presentation/add_tasks/edit_task_screen.dart';
import 'package:task_groove/presentation/auth/forgot_password_screen.dart';
import 'package:task_groove/presentation/auth/login_screen.dart';
import 'package:task_groove/presentation/auth/signup_screen.dart';
import 'package:task_groove/presentation/bottom_navbar/bottom_navbar.dart';
import 'package:task_groove/presentation/home/home_screen.dart';
import 'package:task_groove/presentation/home/widgets/inbox_screen.dart';
import 'package:task_groove/presentation/home/widgets/overdue_task_screen.dart';
import 'package:task_groove/presentation/home/widgets/task_description.dart';
import 'package:task_groove/presentation/home/widgets/today_screen.dart';
import 'package:task_groove/presentation/home/widgets/upcoming_task_screen.dart';
import 'package:task_groove/presentation/profile/widgets/edit_profile.dart';
import 'package:task_groove/routes/pages.dart';

class AppRouter {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This method checks the auth status to set the initial location
  Future<String> getInitialLocation() async {
    User? user = _auth.currentUser;
    return user != null
        ? Pages.bottomNavbar
        : Pages.login; // If authenticated, go to Home, else Login
  }

  Future<GoRouter> createRouter() async {
    final String initialLocation = await getInitialLocation();

    return GoRouter(
      initialLocation: initialLocation,
      routes: <GoRoute>[
        GoRoute(
          path: Pages.home,
          name: Pages.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: Pages.signup,
          name: Pages.signup,
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: Pages.login,
          name: Pages.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: Pages.forgotPassword,
          name: Pages.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: Pages.inboxtask,
          name: Pages.inboxtask,
          builder: (context, state) => const InboxScreen(),
        ),
        GoRoute(
          path: Pages.todaytask,
          name: Pages.todaytask,
          builder: (context, state) => const TodayTaskScreen(),
        ),
        GoRoute(
          path: Pages.upcomingtask,
          name: Pages.upcomingtask,
          builder: (context, state) => const UpcomingTaskScreen(),
        ),
        GoRoute(
          path: Pages.createTask,
          name: Pages.createTask,
          builder: (context, state) => const CreateTaskScreen(),
        ),
        GoRoute(
            path: Pages.overduetask,
            name: Pages.overduetask,
            builder: (context, state) => const OverdueTaskScreen()),
        GoRoute(
          path: Pages.bottomNavbar,
          name: Pages.bottomNavbar,
          builder: (context, state) => const BottomNavigationUserBar(),
        ),
        GoRoute(
          path: Pages.taskDescription,
          name: Pages.taskDescription,
          builder: (context, state) {
            final task = state.extra as TaskModel;
            return TaskDescriptionScreen(task: task);
          },
        ),
        GoRoute(
          path: Pages.editTask,
          name: Pages.editTask,
          builder: (context, state) {
            final task = state.extra as TaskModel;
            return EditTaskScreen(task: task);
          },
        ),
        // GoRoute(
        //   path: Pages.profileDescription,
        //   name: Pages.profileDescription,
        //   builder: (context, state) {
        //     // final task = state.extra as TaskModel;
        //     // return EditTaskScreen(task: task);
        //     return const ProfileDescription();
        //   },
        // ),
        GoRoute(
          path: Pages.profileDescription,
          name: Pages.profileDescription,
          builder: (context, state) {
            final user = state.extra as UserModel; // Cast extra as UserModel

            return ProfileDescription(
                user: user); // Pass the user model to ProfileDescription
          },
        ),

        //  GoRoute(
        //   path: Pages.notificationDescription,
        //   name: Pages.notificationDescription,
        //   builder: (context, state) {
        //     final task = state.extra as TaskModel;
        //     return NotificationDescriptionScreen();
        //   },
        // ),
      ],
    );
  }
}
