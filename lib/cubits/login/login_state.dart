// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';

part of 'login_cubit.dart';

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final CustomError error;

  const LoginState({required this.loginStatus, required this.error});

  factory LoginState.initial() {
    return const LoginState(
      loginStatus: LoginStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [loginStatus, error];

  @override
  bool get stringify => true;

  LoginState copyWith({
    LoginStatus? loginStatus,
    CustomError? error,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      error: error ?? this.error,
    );
  }
}
