import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/presentation/profile/profile_theme/profile_theme_card.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class ProfileThemeScreen extends StatefulWidget {
  const ProfileThemeScreen({super.key});

  @override
  State<ProfileThemeScreen> createState() => _ProfileThemeScreenState();
}

class _ProfileThemeScreenState extends State<ProfileThemeScreen> {
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
    Color? selectedThemeColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Theme",
          style: AppTextStyles.headingBold.copyWith(
            color: Colors.white,
          ),
        ),
        // leading:  IconButton(
        //   // onPressed: () => context.goNamed(Pages.),
        //   color: Colors.white,
        //   icon: FaIcon(
        //     FontAwesomeIcons.arrowLeft,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              for (var theme in themes) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedThemeColor = theme['color'];
                    });
                    context.read<ThemeCubit>().changeTheme(theme['color']);
                  },
                  child: ProfileThemeCard(
                      color: theme['color'],
                      themeTitle: theme['title'],
                      isSelected: theme['color'] == selectedThemeColor),
                ),
                SizedBox(height: 1.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
