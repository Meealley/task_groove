import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/models/forgot_password_status.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/utils/custom_error.dart';
import 'package:task_groove/utils/toast_message_services.dart';

part 'forgotpassword_state.dart';

class ForgotpasswordCubit extends Cubit<ForgotpasswordState> {
  final AuthRepository authRepository;
  ForgotpasswordCubit({required this.authRepository})
      : super(ForgotpasswordState.initial());

  Future<void> resetPassword(
      {required BuildContext context, required String email}) async {
    if (email.isEmpty) {
      emit(
        state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.error,
          error: const CustomError(message: "Email is required"),
        ),
      );

      return;
    }

    emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.loading));

    try {
      await authRepository.forgotPassword(email: email).whenComplete(() {
        ToastService.sendScaffoldAlert(
          msg: "ResetPassword sent to your mail successfully",
          toastStatus: "SUCCESS",
          context: context,
        );
      });
      emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.error,
          error: CustomError(
            code: "Error",
            message: e.toString(),
            plugin: "flutter_error",
          ),
        ),
      );
      // Optionally, you can also show an error toast message
      ToastService.sendScaffoldAlert(
        msg: "Failed to send reset password email: ${e.toString()}",
        toastStatus: "ERROR",
        context: context,
      );
    }
  }
}
