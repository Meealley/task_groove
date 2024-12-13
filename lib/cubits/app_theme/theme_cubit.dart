import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/appcolors.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial()) {
    _loadThemeColor(); // Load the saved theme color when the cubit is created
  }

  // Load the saved theme color from SharedPreferences
  Future<void> _loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final savedColorValue = prefs.getInt('themeColor') ??
        Colors.blue.value; // Default to blue if no saved color
    emit(state.copyWith(color: Color(savedColorValue)));
  }

  // Change the theme color and save it to SharedPreferences
  void changeTheme(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'themeColor', color.value); // Save the color to SharedPreferences
    emit(state.copyWith(color: color)); // Update the state with the new color
  }
}
