// import 'dart:js';

import 'package:go_router/go_router.dart';
import 'package:task_groove/presentation/auth/forgot_password_screen.dart';
import 'package:task_groove/presentation/auth/login_screen.dart';
import 'package:task_groove/presentation/auth/signup_screen.dart';
import 'package:task_groove/presentation/home/home_screen.dart';
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
]);
