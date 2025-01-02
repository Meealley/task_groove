import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/cubits/app_theme/theme_cubit.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  List<Map<String, dynamic>> profileLists = [
    {
      "icon": FontAwesomeIcons.chartArea,
      'title': "Statistics",
      'route': Pages.profileStatistics,
    },
    {
      "icon": FontAwesomeIcons.lock,
      'title': "Change Password",
      'route': Pages.changePassword,
    },
    {
      "icon": FontAwesomeIcons.award,
      'title': "Groove levels",
      'route': Pages.grooveLevel,
    },
    {
      "icon": FontAwesomeIcons.paintbrush,
      'title': "Theme",
      'route': Pages.profileTheme,
    },

    //  This will be implemented in further update
    // {
    //   "icon": FontAwesomeIcons.intercom,
    //   'title': "Calendar Integration",
    //   'route': Pages.profileCalendarIntegration,
    // },
    {
      "icon": FontAwesomeIcons.joomla,
      'title': "Recent Activity",
      'route': Pages.recentActivity,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: profileLists.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final profilesections = profileLists[index];

        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return ListTile(
              leading: Icon(
                profilesections['icon'],
                color: state.color,
              ),
              minVerticalPadding: 0,
              title: Text(
                profilesections['title'],
                style: AppTextStyles.bodySmall,
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                context.push(profilesections['route']);
              },
            );
          },
        );
      },
    );
  }
}
