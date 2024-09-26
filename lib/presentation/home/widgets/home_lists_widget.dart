import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class HomeListWidgets extends StatefulWidget {
  const HomeListWidgets({super.key});

  @override
  State<HomeListWidgets> createState() => _HomeListWidgetsState();
}

class _HomeListWidgetsState extends State<HomeListWidgets> {
  final List<Map<String, dynamic>> taskSections = [
    {
      "icon": const FaIcon(FontAwesomeIcons.inbox),
      'title': 'Inbox',
      'route': Pages.inboxtask
    },
    {
      "icon": const FaIcon(FontAwesomeIcons.calendar),
      'title': 'Today',
      'route': Pages.todaytask
    },
    {
      "icon": const FaIcon(FontAwesomeIcons.calendarXmark),
      'title': 'Upcoming',
      'route': Pages.upcomingtask
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, index) {
          return const Divider();
        },
        shrinkWrap: true,
        itemCount: taskSections.length,
        itemBuilder: (context, index) {
          final sections = taskSections[index];

          return ListTile(
            leading: sections['icon'],
            minVerticalPadding: 0,
            title: Text(
              sections['title']!,
              style: AppTextStyles.bodyText,
            ),
            onTap: () {
              context.push(sections['route']!);
            },
          );
        },
      ),
    );
  }
}
