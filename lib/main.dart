import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/forgotpassword/forgotpassword_cubit.dart';
import 'package:task_groove/cubits/login/login_cubit.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/firebase_options.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/routes/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
