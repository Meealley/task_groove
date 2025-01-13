import 'dart:developer';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_groove/cubits/login/login_cubit.dart';
import 'package:task_groove/models/login_status.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/utils/custom_error.dart';
import 'package:task_groove/utils/toast_message_services.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockToastService extends Mock implements ToastService {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late LoginCubit loginCubit;
  late MockAuthRepository mockAuthRepository;
  late MockToastService mockToastService;
  late MockBuildContext mockBuildContext;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockToastService = MockToastService();
    mockBuildContext = MockBuildContext();
    loginCubit = LoginCubit(authRepository: mockAuthRepository);
  });

  tearDown(() {
    loginCubit.close();
  });

  group('LoginCubit', () {
    test('initial state is LoginState.initial()', () {
      expect(loginCubit.state, LoginState.initial());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] when login succeeds',
      build: () {
        when(() => mockAuthRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Future.value());

        return loginCubit;
      },
      act: (cubit) => cubit.login(
        context: mockBuildContext,
        email: 'test@example.com',
        password: 'password123',
      ),
      expect: () => [
        LoginState.initial().copyWith(loginStatus: LoginStatus.loading),
        LoginState.initial().copyWith(loginStatus: LoginStatus.success),
      ],
      // verify: (_) {
      //   verify(() => mockToastService.sendScaffoldAlert(
      //         msg: "User Login",
      //         toastStatus: "SUCCESS",
      //         context: mockBuildContext,
      //       )).called(1);
      // },
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, error] when login fails',
      build: () {
        when(() => mockAuthRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Login Failed'));

        return loginCubit;
      },
      act: (cubit) => cubit.login(
        context: mockBuildContext,
        email: 'test@example.com',
        password: 'password123',
      ),
      expect: () => [
        LoginState.initial().copyWith(loginStatus: LoginStatus.loading),
        LoginState.initial().copyWith(
          loginStatus: LoginStatus.error,
          error: const CustomError(
            code: "LoginError",
            message: 'Exception: Login Failed',
            plugin: "flutter_error",
          ),
        ),
      ],
      // verify: (_) {
      //   verify(() => mockToastService.sendScaffoldAlert(
      //         msg: "Login Failed: Exception: Login Failed",
      //         toastStatus: "ERROR",
      //         context: mockBuildContext,
      //       )).called(1);
      // },
    );
  });
}
