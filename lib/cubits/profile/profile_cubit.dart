// profile_cubit.dart
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:task_groove/repositories/auth_repository.dart'; // Ensure the correct import
import 'package:task_groove/repository/auth_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;

  ProfileCubit({required this.authRepository}) : super(ProfileState.initial());

  // Fetch the current user's profile data
  Future<void> fetchUserProfile() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null && user.name.isNotEmpty) {
        log(user.points.toString());
        emit(state.copyWith(
          name: user.name,
          loginStreak: user.loginStreak, // Adjust UserModel if needed
          points: user.points, // Adjust UserModel if needed
          isLoading: false,
          email: user.email,
          profileImageUrl: user.profilePicsUrl,
        ));
      } else {
        emit(state.copyWith(
          errorMessage: "User not found",
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  // Track login streak
  Future<void> trackLogin() async {
    log("Tracking login...");
    try {
      await authRepository.trackDailyAppUsage();
      log("Login tracked successfully");
      await fetchUserProfile(); // Refresh the profile after tracking login
    } catch (e) {
      log("Error tracking login: $e");
    }
  }

  // Award points
  Future<void> awardPoints(int points) async {
    await authRepository.awardPoints(points);
    await fetchUserProfile(); // Refresh the profile after awarding points
  }
}
