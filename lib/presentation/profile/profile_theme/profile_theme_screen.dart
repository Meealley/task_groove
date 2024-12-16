import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/presentation/profile/profile_theme/profile_theme_card.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class ProfileThemeScreen extends StatefulWidget {
  const ProfileThemeScreen({super.key});

  @override
  State<ProfileThemeScreen> createState() => _ProfileThemeScreenState();
}

class _ProfileThemeScreenState extends State<ProfileThemeScreen> {
  Color? selectedThemeColor; // Persist selected theme color

  @override
  Widget build(BuildContext context) {
    // List of themes for dynamic rendering
    final List<Map<String, dynamic>> themes = [
      {'color': AppColors.backgroundDark, 'title': 'Dark Theme'},
      {'color': Colors.black, 'title': 'Black Theme'},
      {'color': Colors.orange, 'title': 'Orange Theme'},
      {'color': Colors.green, 'title': 'Green Theme'},
      {'color': Colors.yellow, 'title': 'Yellow Theme'},
      {'color': Colors.pink, 'title': 'Pink Theme'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Theme",
          style: AppTextStyles.headingBold.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: themes.length,
            itemBuilder: (context, index) {
              final theme = themes[index];
              return Column(
                children: [
                  ProfileThemeCard(
                    onTap: () {
                      setState(() {
                        selectedThemeColor = theme['color'];
                      });
                      context.read<ThemeCubit>().changeTheme(
                            theme['color'],
                            index,
                          );
                    },
                    color: theme['color'],
                    themeTitle: theme['title'],
                    isSelected: state.selectedThemeIndex == index,
                  ),
                  SizedBox(height: 1.h),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
