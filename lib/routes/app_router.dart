// import 'dart:js';

import 'package:go_router/go_router.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/presentation/add_tasks/create_task_screen.dart';
import 'package:task_groove/presentation/add_tasks/edit_task_screen.dart';
import 'package:task_groove/presentation/auth/forgot_password_screen.dart';
import 'package:task_groove/presentation/auth/login_screen.dart';
import 'package:task_groove/presentation/auth/signup_screen.dart';
import 'package:task_groove/presentation/bottom_navbar/bottom_navbar.dart';
import 'package:task_groove/presentation/home/home_screen.dart';
import 'package:task_groove/presentation/home/widgets/inbox_screen.dart';
import 'package:task_groove/presentation/home/widgets/task_description.dart';
import 'package:task_groove/presentation/home/widgets/today_screen.dart';
import 'package:task_groove/presentation/home/widgets/upcoming_task_screen.dart';
import 'package:task_groove/routes/pages.dart';

final GoRouter appRouter =
    GoRouter(initialLocation: Pages.login, routes: <RouteBase>[
  GoRoute(
    path: Pages.home,
    name: Pages.home,
    builder: (context, state) {
      return const HomeScreen();
    },
  ),
  GoRoute(
    path: Pages.signup,
    name: Pages.signup,
    builder: (context, state) {
      return const SignupScreen();
    },
  ),
  GoRoute(
    path: Pages.login,
    name: Pages.login,
    builder: (context, state) {
      return const LoginScreen();
    },
  ),
  GoRoute(
    path: Pages.forgotPassword,
    name: Pages.forgotPassword,
    builder: (context, state) {
      return const ForgotPasswordScreen();
    },
  ),
  GoRoute(
    path: Pages.inboxtask,
    name: Pages.inboxtask,
    builder: (context, state) {
      return const InboxScreen();
    },
  ),
  GoRoute(
    path: Pages.todaytask,
    name: Pages.todaytask,
    builder: (context, state) {
      return const TodayTaskScreen();
    },
  ),
  GoRoute(
    path: Pages.upcomingtask,
    name: Pages.upcomingtask,
    builder: (context, state) {
      return const UpcomingTaskScreen();
    },
  ),
  GoRoute(
    path: Pages.createTask,
    name: Pages.createTask,
    builder: (context, state) {
      return const CreateTaskScreen();
    },
  ),
  GoRoute(
    path: Pages.bottomNavbar,
    name: Pages.bottomNavbar,
    builder: (context, state) {
      return const BottomNavigationUserBar();
    },
  ),
  GoRoute(
    path: Pages.taskDescription,
    name: Pages.taskDescription,
    builder: (context, state) {
      final task = state.extra as TaskModel; // Pass task as extra
      return TaskDescriptionScreen(task: task);
    },
  ),
  GoRoute(
      path: Pages.editTask,
      name: Pages.editTask,
      builder: (context, state) {
        final task = state.extra as TaskModel;
        return EditTaskScreen(task: task);
      })
]);
