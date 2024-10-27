// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/active_task_count/active_task_count_cubit.dart';
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
import 'package:task_groove/firebase_options.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/repository/push_notification_repository.dart';
import 'package:task_groove/repository/recent_activity_repository.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/routes/app_router.dart'; // Import AppRouter
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:task_groove/theme/appcolors.dart';

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

  // Initialize HydratedStorage
  // HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory: kIsWeb
  //       ? HydratedStorage.webStorageDirectory
  //       : await getTemporaryDirectory(),
  // );

  // Initialize the app router
  final appRouter = AppRouter();
  final goRouter = await appRouter.createRouter(); // Create router dynamically

  runApp(MyApp(
    authRepository: AuthRepository(),
    goRouter: goRouter, // Pass the GoRouter instance
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final GoRouter goRouter; // Accept GoRouter as a parameter

  const MyApp({
    super.key,
    required this.authRepository,
    required this.goRouter, // GoRouter parameter
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
        BlocProvider<OverdueTaskCubit>(
          create: (context) =>
              OverdueTaskCubit(taskRepository: TaskRepository()),
        ),
        BlocProvider<RecentActivityCubit>(
          create: (context) => RecentActivityCubit(
            recentActivityRepository: RecentActivityRepository(),
          ),
        ),
      ],
      child: Sizer(
        builder: (context, _, __) {
          return MaterialApp.router(
            theme: ThemeData(
              colorScheme: ColorScheme(
                brightness: Brightness.light,
                primary: AppColors.backgroundDark,
                secondary: Colors.green,
                surface: Colors.grey.shade200,
                background: Colors.grey.shade200,
                error: Colors.red,
                onPrimary: Colors.grey.shade200,
                onSecondary: Colors.grey.shade200,
                onSurface: Colors.black,
                onBackground: Colors.grey.shade400,
                onError: Colors.white,
              ),
            ),
            routerConfig: goRouter, // Use the dynamic GoRouter
            debugShowCheckedModeBanner: false,
            title: "Task Groove",
          );
        },
      ),
    );
  }
}
