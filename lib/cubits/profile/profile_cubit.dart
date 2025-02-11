import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_groove/repository/auth_repository.dart';
import 'package:task_groove/utils/toast_message_services.dart';
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
          userID: user.userID,
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
      // await authRepository.trackDailyAppUsage();
      await authRepository.trackLogin();
      log("Login tracked successfully");
      await fetchUserProfile(); // Refresh the profile after tracking login
    } catch (e) {
      log("Error tracking login: $e");
    }
  }

  // Update User Profile
  Future<void> updateUserProfile({
    required BuildContext context,
    required String name,
    required String email,
    String? profileImageUrl,
  }) async {
    emit(state.copyWith(isLoading: true)); // Emit loading state

    try {
      // Update Firestore via the repository
      await authRepository
          .updateUserProfile(
        userId: state.userID,
        name: name,
        email: email,
        profileImageUrl: profileImageUrl,
      )
          .whenComplete(() {
        ToastService.sendScaffoldAlert(
          msg: "Profile Updated",
          toastStatus: "SUCCESS",
          context: context,
        );
      });

      log("User profile updated successfully in Firestore");

      // Update local state
      final updatedState = state.copyWith(
        name: name,
        email: email,
        profileImageUrl: profileImageUrl ?? state.profileImageUrl,
        isLoading: false,
        errorMessage: null,
      );

      emit(updatedState);

      // Save to SharedPreferences
      await saveProfileToSharedPreferences(updatedState);
      // Load the updated profile immediately after saving it to SharedPreferences
      // await loadProfileFromSharedPreferences();
    } catch (e) {
      log("Error updating user profile: $e");

      emit(state.copyWith(
        errorMessage: 'Failed to update profile. Please try again later.',
        isLoading: false, // Reset loading state
      ));
    }
  }

  Future<void> saveProfileToSharedPreferences(ProfileState profileState) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert the state to a JSON string
    final profileMap = {
      'user_uid': profileState.userID,
      'user_name': profileState.name,
      'user_email': profileState.email,
      'user_profilePicsUrl': profileState.profileImageUrl,
      'user_loginStreak': profileState.loginStreak,
      'user_points': profileState.points,
    };

    final profileJson = jsonEncode(profileMap); // Encode as JSON
    await prefs.setString(
        'profileState', profileJson); // Save to SharedPreferences
    log("Profile saved to SharedPreferences");
  }

  Future<ProfileState> loadProfileFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = prefs.getString('profileState');

    if (profileData != null) {
      try {
        final profileMap =
            jsonDecode(profileData) as Map<String, dynamic>; // Decode JSON

        // return ProfileState(
        //   userID: profileMap['userID'] ?? "",
        //   name: profileMap['name'] ?? "",
        //   email: profileMap['email'] ?? "",
        //   profileImageUrl: profileMap['profileImageUrl'] ?? "",
        //   loginStreak: profileMap['loginStreak'] ?? 1,
        //   points: profileMap['points'] ?? 0,
        //   isLoading: false,
        //   errorMessage: null,
        // );
        emit(state.copyWith(
          userID: profileMap['user_uid'] ?? "",
          name: profileMap['user_name'] ?? "",
          email: profileMap['user_email'] ?? "",
          profileImageUrl: profileMap['user_profilePicsUrl'] ?? "",
          loginStreak: profileMap['user_loginStreak'] ?? 1,
          points: profileMap['user_points'] ?? 0,
          isLoading: false,
          errorMessage: null,
        ));
      } catch (e) {
        log("Error decoding profile from SharedPreferences: $e");
      }
    }

    // Return initial state if no data is found or decoding fails
    return ProfileState.initial();
  }
}
