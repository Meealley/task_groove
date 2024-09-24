import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/models/signup_status.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/utils/custom_error.dart';
import 'package:task_groove/utils/toast_message_services.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;

  SignupCubit({required this.authRepository}) : super(SignupState.initial());

  Future<void> signup({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required File? profileImage, // Accept image as a parameter
  }) async {
    if (profileImage == null) {
      emit(state.copyWith(
          error: const CustomError(message: "No Image selected")));
      return;
    }

    emit(state.copyWith(signUpStatus: SignUpStatus.loading));

    try {
      await authRepository
          .signUp(
        name: name,
        email: email,
        password: password,
        profileImage: profileImage, // Pass image here
      )
          .whenComplete(() {
        ToastService.sendScaffoldAlert(
          msg: "User Created",
          toastStatus: "SUCCESS",
          context: context,
        );
      });
      emit(state.copyWith(signUpStatus: SignUpStatus.success));
      log("User signed up successfully : $name, $email, $profileImage");
    } catch (e) {
      emit(
        state.copyWith(
          signUpStatus: SignUpStatus.error,
          error: CustomError(
            code: "Error",
            message: e.toString(),
            plugin: "flutter_error",
          ),
        ),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await authRepository
          .signOut(); // Call the signOut method from AuthRepository
      emit(state.copyWith(
          signUpStatus:
              SignUpStatus.initial)); // Reset state or handle as needed

      ToastService.sendScaffoldAlert(
        msg: "Signed Out Successfully",
        toastStatus: "SUCCESS",
        context: context,
      );
      // Navigate to sign-up or login screen after successful sign-out
      context.go(
        Pages.login,
      ); // Make sure 'Pages.signup' is the correct path for your login/signup page

      log("User logged out successfully");
    } catch (e) {
      emit(
        state.copyWith(
          signUpStatus: SignUpStatus.error,
          error: CustomError(
            code: "Error",
            message: e.toString(),
            plugin: "flutter_error",
          ),
        ),
      );
    }
  }
}
