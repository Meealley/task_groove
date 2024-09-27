import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/active_task_count/active_task_count_cubit.dart';
import 'package:task_groove/cubits/task_progress/task_progress_cubit.dart';
import 'package:task_groove/cubits/forgotpassword/forgotpassword_cubit.dart';
import 'package:task_groove/cubits/login/login_cubit.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/firebase_options.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/routes/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

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
      ],
      child: Sizer(
        builder: (context, _, __) {
          return MaterialApp.router(
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            title: "Task Groove",
          );
        },
      ),
    );
  }
}
