import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_groove/cubits/signup/signup_cubit.dart';
import 'package:task_groove/models/signup_status.dart';
import 'package:task_groove/models/user_model.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockFile extends Mock implements File {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late SignupCubit signupCubit;
  late MockAuthRepository mockAuthRepository;
  late MockFile mockFile;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signupCubit = SignupCubit(authRepository: mockAuthRepository);
    mockFile = MockFile();

    // Mock the behavior of the file to avoid late initialization errors
    when(() => mockFile.path).thenReturn('test_path.png');
    when(() => mockFile.exists()).thenAnswer((_) async => true);
  });

  tearDown(() {
    signupCubit.close();
  });

  group(
    'SignupCubit',
    () {
      test('initial state is SignupState.initial()', () {
        expect(signupCubit.state, SignupState.initial());
      });

      blocTest<SignupCubit, SignupState>(
        'emits [loading, success] when signup succeeds',
        build: () {
          when(
            () => mockAuthRepository.signUp(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
              profileImage: any(named: 'profileImage'),
            ),
          ).thenAnswer((_) async => UserModel(
                userID: '1',
                name: 'Test User',
                email: 'test@example.com',
                profilePicsUrl: 'https://example.com',
                loginStreak: 0,
                points: 0,
                lastUsage: DateTime.now(),
              ));

          return signupCubit;
        },
        act: (cubit) => cubit.signup(
          context: MockBuildContext(),
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          profileImage: mockFile,
        ),
        expect: () => [
          SignupState.initial().copyWith(signUpStatus: SignUpStatus.loading),
          SignupState.initial().copyWith(signUpStatus: SignUpStatus.success),
        ],
      );

      blocTest<SignupCubit, SignupState>(
        'emits [loading, error] when signup fails',
        build: () {
          when(
            () => mockAuthRepository.signUp(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
              profileImage: any(named: 'profileImage'),
            ),
          ).thenThrow(Exception('Signup Failed'));
          return signupCubit;
        },
        act: (cubit) => cubit.signup(
          context: MockBuildContext(),
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          profileImage: mockFile,
        ),
        expect: () => [
          SignupState.initial().copyWith(signUpStatus: SignUpStatus.loading),
          SignupState.initial().copyWith(
            signUpStatus: SignUpStatus.error,
            error: const CustomError(
              code: "Error",
              message: 'Exception: Signup Failed',
              plugin: "flutter_error",
            ),
          ),
        ],
      );

      blocTest<SignupCubit, SignupState>(
        'emits error when profile image is null',
        build: () => signupCubit,
        act: (cubit) => cubit.signup(
          context: MockBuildContext(),
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          profileImage: null,
        ),
        expect: () => [
          SignupState.initial().copyWith(
            error: const CustomError(message: "No Image selected"),
          ),
        ],
      );
    },
  );
}
