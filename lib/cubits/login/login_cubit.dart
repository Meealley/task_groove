import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/models/login_status.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/utils/custom_error.dart';
import 'package:task_groove/utils/toast_message_services.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  LoginCubit({required this.authRepository}) : super(LoginState.initial());

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    try {
      await authRepository
          .login(email: email, password: password)
          .whenComplete(() {
        ToastService.sendScaffoldAlert(
          msg: "User Login",
          toastStatus: "SUCCESS",
          context: context,
        );
      });

      emit(state.copyWith(loginStatus: LoginStatus.success));

      log("User logged in successfully");
    } catch (e) {
      final error = CustomError(
        code: "LoginError",
        message: e.toString(),
        plugin: "flutter_error",
      );
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        // error: CustomError(
        //   code: "Error",
        //   message: e.toString(),
        //   plugin: "flutter_error",
        // ),
        error: error,
      ));

      // Show error message if login fails
      ToastService.sendScaffoldAlert(
        msg: "Login Failed: ${error.userMessage}",
        toastStatus: "ERROR",
        context: context,
      );

      log("Login failed: $e");
    }
  }
}
