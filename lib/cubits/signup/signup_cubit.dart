import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/models/signup_status.dart';
import 'package:task_groove/models/user_model.dart';
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
    required File? profileImage,
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
        profileImage: profileImage,
      )
          .then((_) {
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

// Google Sign-In method
  Future<void> googleSignInMethod(BuildContext context) async {
    emit(state.copyWith(signUpStatus: SignUpStatus.loading));

    try {
      // Call signInWithGoogle from AuthRepository
      UserModel user = await authRepository.signInWithGoogle();

      ToastService.sendScaffoldAlert(
        msg: "Google Sign-In Successful",
        toastStatus: "SUCCESS",
        context: context,
      );

      emit(state.copyWith(
        signUpStatus: SignUpStatus.success,
      ));

      log("User signed in with Google: ${user.name}");

      // Navigate to the home
      context.go(Pages.bottomNavbar);
    } catch (e) {
      emit(
        state.copyWith(
          signUpStatus: SignUpStatus.error,
          error: CustomError(
            code: "GoogleSignInError",
            message: e.toString(),
            plugin: "firebase_auth",
          ),
        ),
      );
      log("Error signing in with Google: $e");
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await authRepository.signOut();
      emit(state.copyWith(signUpStatus: SignUpStatus.initial));
      ToastService.sendScaffoldAlert(
        msg: "Signed Out Successfully",
        toastStatus: "SUCCESS",
        context: context,
      );

      context.go(
        Pages.login,
      );

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
