// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/cubits/active_task_count/active_task_count_cubit.dart';
import 'package:task_groove/cubits/completed_task_per_day/completed_task_per_day_cubit.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/cubits/completed_task_per_week/completed_task_per_week_cubit.dart';
import 'package:task_groove/cubits/daily_goals/daily_goals_cubit.dart';
import 'package:task_groove/cubits/daily_streak/daily_streak_cubit.dart';
import 'package:task_groove/cubits/goal_celebration/goal_celebration_cubit.dart';
import 'package:task_groove/cubits/google_calendar/google_calender_cubit.dart';
import 'package:task_groove/cubits/groove_level/groove_level_cubit.dart';
import 'package:task_groove/cubits/overdue_task/overdue_task_cubit.dart';
import 'package:task_groove/cubits/recent_activity/recent_activity_cubit.dart';
import 'package:task_groove/cubits/profile/profile_cubit.dart';
import 'package:task_groove/cubits/search_task/search_task_cubit.dart';
import 'package:task_groove/cubits/task_progress/task_progress_cubit.dart';
import 'package:task_groove/cubits/forgotpassword/forgotpassword_cubit.dart';
import 'package:task_groove/cubits/login/login_cubit.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/cubits/today_task/today_task_cubit.dart';
import 'package:task_groove/cubits/total_completed_task_count/total_completed_task_count_cubit.dart';
import 'package:task_groove/cubits/walkthrough/walkthrough_cubit.dart';
import 'package:task_groove/cubits/weekly_goals/weekly_goals_cubit.dart';
import 'package:task_groove/firebase_options.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/repository/daily_streak_repository.dart';
import 'package:task_groove/repository/google_calendar_repository.dart';
import 'package:task_groove/repository/push_notification_repository.dart';
import 'package:task_groove/repository/recent_activity_repository.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/routes/app_router.dart'; // Import AppRouter
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  // Initialize the push notification repository
  PushNotificationRepository pushNotificationRepository =
      PushNotificationRepository();

  // Request permission for push notifications
  await pushNotificationRepository.requestPermission();

  // Get the FCM token
  await pushNotificationRepository.getFcmToken();

  // Set foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print(
          'Message received in foreground: ${message.notification!.title}, ${message.notification!.body}');
    }
  });

  // Handle background and terminated state messages
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print(
        'Message clicked: ${message.notification?.title}, ${message.notification?.body}');
  });

  // Initialize the app router
  final appRouter = AppRouter();
  final goRouter = await appRouter.createRouter();

  runApp(MyApp(
    authRepository: AuthRepository(),
    goRouter: goRouter,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final GoRouter goRouter;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.goRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupCubit>(
          create: (context) => SignupCubit(authRepository: authRepository),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(authRepository: authRepository),
        ),
        BlocProvider<ForgotpasswordCubit>(
          create: (context) =>
              ForgotpasswordCubit(authRepository: authRepository),
        ),
        BlocProvider<TaskListCubit>(
          create: (context) => TaskListCubit(
            taskRepository: TaskRepository(),
            pushNotificationRepository: PushNotificationRepository(),
          ),
        ),
        BlocProvider<TaskProgressCubit>(
          create: (context) => TaskProgressCubit(
            taskListCubit: context.read<TaskListCubit>(),
          ),
        ),
        BlocProvider<ActiveTaskCountCubit>(
          create: (context) => ActiveTaskCountCubit(
            taskListCubit: context.read<TaskListCubit>(),
          ),
        ),
        BlocProvider<SearchTaskCubit>(
          create: (context) => SearchTaskCubit(
            taskRepository: TaskRepository(),
          ),
        ),
        BlocProvider<TodayTaskCubit>(
          create: (context) => TodayTaskCubit(
            taskListCubit: context.read<TaskListCubit>(),
          ),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(authRepository: authRepository),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<TotalCompletedTaskCountCubit>(
          create: (context) => TotalCompletedTaskCountCubit(
              taskListCubit: context.read<TaskListCubit>()),
        ),
        BlocProvider<CompletedTaskPerDayCubit>(
          create: (context) => CompletedTaskPerDayCubit(
              taskListCubit: context.read<TaskListCubit>()),
        ),
        BlocProvider<OverdueTaskCubit>(
          create: (context) =>
              OverdueTaskCubit(taskRepository: TaskRepository()),
        ),
        BlocProvider<RecentActivityCubit>(
          create: (context) => RecentActivityCubit(
            recentActivityRepository: RecentActivityRepository(),
          ),
        ),
        BlocProvider<GoogleCalenderCubit>(
          create: (context) => GoogleCalenderCubit(
            googleCalendarRepository: GoogleCalendarRepository(),
          ),
        ),
        BlocProvider<DailyGoalsCubit>(
          create: (context) => DailyGoalsCubit(
            completedTaskPerDayCubit: CompletedTaskPerDayCubit(
                taskListCubit: context.read<TaskListCubit>()),
          ),
        ),
        BlocProvider<WeeklyGoalsCubit>(
          create: (context) => WeeklyGoalsCubit(
            completedTaskPerWeekCubit: CompletedTaskPerWeekCubit(
                taskListCubit: context.read<TaskListCubit>()),
          ),
        ),
        BlocProvider<GoalCelebrationCubit>(
          create: (context) => GoalCelebrationCubit(
            dailyGoalsCubit: context.read<DailyGoalsCubit>(),
          ),
        ),
        BlocProvider<DailyStreakCubit>(
          create: (context) => DailyStreakCubit(
            streakRepository: DailyStreakRepository(
              userId: auth.currentUser!.uid,
            ),
          ),
        ),
        BlocProvider<GrooveLevelCubit>(
          create: (context) => GrooveLevelCubit(
            taskRepository: TaskRepository(),
          ),
        ),
        // BlocProvider<WalkthroughCubit>(
        //   create: (context) => WalkthroughCubit(),
        // ),
      ],
      child: Sizer(
        builder: (context, _, __) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp.router(
                theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    actionsIconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    backgroundColor:
                        state.color, // Set AppBar color dynamically
                  ),
                  primaryColor: state.color,
                  colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: state.color,
                    secondary: Colors.green,
                    surface: Colors.grey.shade200,
                    error: Colors.red,
                    onPrimary: Colors.grey.shade200,
                    onSecondary: Colors.grey.shade200,
                    onSurface: Colors.black,
                    onError: Colors.white,
                  ),
                  dividerColor: Colors.grey,
                ),
                routerConfig: goRouter, // Use the dynamic GoRouter
                debugShowCheckedModeBanner: false,
                title: "Task Groove",
              );
            },
          );
        },
      ),
    );
  }
}
