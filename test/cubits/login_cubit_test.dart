// import 'dart:developer';

// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:task_groove/cubits/login/login_cubit.dart';
// import 'package:task_groove/models/login_status.dart';
// import 'package:task_groove/repository/auth_repository.dart';
// import 'package:task_groove/utils/custom_error.dart';
// import 'package:task_groove/utils/toast_message_services.dart';
// import 'package:sizer/sizer.dart';

// // Mock classes
// class MockAuthRepository extends Mock implements AuthRepository {}
// class MockToastService extends Mock implements ToastService {}
// class MockBuildContext extends Mock implements BuildContext {}

// // Mocking SizerUtil
// class MockSizerUtil extends Mock implements SizerUtil {}

// void main() {
//   late LoginCubit loginCubit;
//   late MockAuthRepository mockAuthRepository;
//   late MockToastService mockToastService;
//   late MockBuildContext mockBuildContext;

//   // Mock the screen width and height for the test
//   late MockSizerUtil mockSizerUtil;

//   setUp(() {
//     // Initialize mock objects
//     mockAuthRepository = MockAuthRepository();
//     mockToastService = MockToastService();
//     mockBuildContext = MockBuildContext();
//     mockSizerUtil = MockSizerUtil();

//     // Mock the screen size and textScaleFactor
//     when(() => mockSizerUtil.width).thenReturn(360.0);  // mock width (logical pixels)
//     when(() => mockSizerUtil.height).thenReturn(640.0); // mock height (logical pixels)
//     when(() => mockSizerUtil.textScaleFactor).thenReturn(1.0);  // optional, mock text scale factor

//     // Inject the mock SizerUtil into the test environment if needed
//     // This step is required if you rely on SizerUtil in your app. Otherwise, skip this part.

//     loginCubit = LoginCubit(authRepository: mockAuthRepository);
//   });

//   tearDown(() {
//     loginCubit.close();
//   });

//   group('LoginCubit', () {
//     test('initial state is LoginState.initial()', () {
//       expect(loginCubit.state, LoginState.initial());
//     });

//     blocTest<LoginCubit, LoginState>(
//       'emits [loading, success] when login succeeds',
//       build: () {
//         when(() => mockAuthRepository.login(
//               email: any(named: 'email'),
//               password: any(named: 'password'),
//             )).thenAnswer((_) async => Future.value());

//         return loginCubit;
//       },
//       act: (cubit) => cubit.login(
//         context: mockBuildContext,
//         email: 'test@example.com',
//         password: 'password123',
//       ),
//       expect: () => [
//         LoginState.initial().copyWith(loginStatus: LoginStatus.loading),
//         LoginState.initial().copyWith(loginStatus: LoginStatus.success),
//       ],
//     );

//     blocTest<LoginCubit, LoginState>(
//       'emits [loading, error] when login fails',
//       build: () {
//         when(() => mockAuthRepository.login(
//               email: any(named: 'email'),
//               password: any(named: 'password'),
//             )).thenThrow(Exception('Login Failed'));

//         return loginCubit;
//       },
//       act: (cubit) => cubit.login(
//         context: mockBuildContext,
//         email: 'test@example.com',
//         password: 'password123',
//       ),
//       expect: () => [
//         LoginState.initial().copyWith(loginStatus: LoginStatus.loading),
//         LoginState.initial().copyWith(
//           loginStatus: LoginStatus.error,
//           error: const CustomError(
//             code: "LoginError",
//             message: 'Exception: Login Failed',
//             plugin: "flutter_error",
//           ),
//         ),
//       ],
//     );
//   });
// }
