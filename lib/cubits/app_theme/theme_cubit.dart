import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/appcolors.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial()) {
    _loadThemeColor();
  }

  Future<void> _loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final savedColorValue =
        prefs.getInt('themeColor') ?? AppColors.backgroundDark.value;
    final savedThemeIndex = prefs.getInt('selectedThemeIndex') ?? 0;
    emit(
      state.copyWith(
        color: Color(
          savedColorValue,
        ),
        selectedThemeIndex: savedThemeIndex,
      ),
    );
  }

  // Change the theme color and save it to SharedPreferences
  void changeTheme(Color color, int themeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', color.value);
    await prefs.setInt('selectedThemeIndex', themeIndex);
    emit(state.copyWith(
      color: color,
      selectedThemeIndex: themeIndex,
    ));
  }
}
