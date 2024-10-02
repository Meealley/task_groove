import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/active_task_count/active_task_count_cubit.dart';
import 'package:task_groove/cubits/profile/profile_cubit.dart';
import 'package:task_groove/cubits/recent_activity/recent_activity_cubit.dart';
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
import 'package:task_groove/routes/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/network_aware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// Initialize the push notification repository
  PushNotificationRepository pushNotificationRepository =
      PushNotificationRepository();

  // Request permission
  await pushNotificationRepository.requestPermission();

  // Get the FCM token
  await pushNotificationRepository.getFcmToken();

  // Set foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print(
          'Message received in foreground: ${message.notification!.title}, ${message.notification!.body}');
      // Show a notification or handle it as needed
    }
  });

  // Handle background and terminated state messages
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print(
        'Message clicked: ${message.notification?.title}, ${message.notification?.body}');
    // Handle navigation to specific screen or logic
  });

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  await dotenv.load(fileName: ".env");
  runApp(MyApp(
    authRepository: AuthRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

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
        BlocProvider<TodayTaskCubit>(
          create: (context) => TodayTaskCubit(
            taskListCubit: context.read<TaskListCubit>(),
          ),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(authRepository: authRepository),
        ),
        BlocProvider<RecentActivityCubit>(
          create: (context) => RecentActivityCubit(
            recentActivityRepository: RecentActivityRepository(),
          ),
        ),
      ],
      child: NetworkAwareWidget(
        child: Sizer(
          builder: (context, _, __) {
            return MaterialApp.router(
              theme: ThemeData(
                colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: AppColors.backgroundDark, // Set the primary color

                  secondary: Colors.green, // Set the secondary color

                  surface: Colors
                      .grey.shade200, // Set the color for surface elements
                  background: Colors.grey.shade200, // Set the background color
                  error: Colors.red, // Set the error color
                  onPrimary:
                      Colors.grey.shade200, // Set the text color on primary
                  onSecondary:
                      Colors.grey.shade200, // Set the text color on secondary
                  onSurface: Colors.black, // Set the text color on surface
                  onBackground:
                      Colors.grey.shade400, // Set the text color on background
                  onError: Colors.white, // Set the text color on error
                ),
              ),
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              title: "Task Groove",
            );
          },
        ),
      ),
    );
  }
}
