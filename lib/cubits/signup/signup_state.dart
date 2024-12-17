// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'signup_cubit.dart';

class SignupState extends Equatable {
  final SignUpStatus signUpStatus;
  final CustomError error;

  const SignupState({required this.signUpStatus, required this.error});

  factory SignupState.initial() {
    return const SignupState(
      signUpStatus: SignUpStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [signUpStatus, error];

  @override
  bool get stringify => true;

  SignupState copyWith({
    SignUpStatus? signUpStatus,
    CustomError? error,
  }) {
    return SignupState(
      signUpStatus: signUpStatus ?? this.signUpStatus,
      error: error ?? this.error,
    );
  }
}
