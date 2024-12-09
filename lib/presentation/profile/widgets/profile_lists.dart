import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
      "icon": const FaIcon(
        FontAwesomeIcons.line,
        color: Colors.blue,
      ),
      'title': "Statistics",
      'route': Pages.profileStatistics,
    },
    {
      "icon": const FaIcon(
        FontAwesomeIcons.line,
        color: Colors.blue,
      ),
      'title': "Security",
      'route': Pages.profileStatistics,
    },
    {
      "icon": const FaIcon(
        FontAwesomeIcons.line,
        color: Colors.blue,
      ),
      'title': "Calendar Integration",
      'route': Pages.profileCalendarIntegration,
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

        return ListTile(
          leading: profilesections['icon'],
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
  }
}
