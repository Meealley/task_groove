// import 'dart:js';

import 'package:go_router/go_router.dart';
import 'package:task_groove/presentation/auth/signup_screen.dart';
import 'package:task_groove/presentation/home/home_screen.dart';
import 'package:task_groove/routes/pages.dart';

final GoRouter appRouter =
    GoRouter(initialLocation: Pages.signup, routes: <RouteBase>[
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
  // GoRoute(
  //   path: Pages.home,
  //   name: Pages.home,
  //   builder: (context, state) {
  //     return const HomeScreen();
  //   },
  // ),
]);
