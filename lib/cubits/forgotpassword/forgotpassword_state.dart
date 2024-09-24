// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';

part of 'forgotpassword_cubit.dart';

class ForgotpasswordState extends Equatable {
  final ForgotPasswordStatus forgotPasswordStatus;
  final CustomError error;

  const ForgotpasswordState(
      {required this.forgotPasswordStatus, required this.error});

  factory ForgotpasswordState.initial() {
    return const ForgotpasswordState(
      forgotPasswordStatus: ForgotPasswordStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [forgotPasswordStatus, error];

  @override
  bool get stringify => true;

  ForgotpasswordState copyWith({
    ForgotPasswordStatus? forgotPasswordStatus,
    CustomError? error,
  }) {
    return ForgotpasswordState(
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      error: error ?? this.error,
    );
  }
}
