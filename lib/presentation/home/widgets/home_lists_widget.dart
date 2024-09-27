import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/cubits/active_task_count/active_task_count_cubit.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class HomeListWidgets extends StatefulWidget {
  const HomeListWidgets({super.key});

  @override
  State<HomeListWidgets> createState() => _HomeListWidgetsState();
}

class _HomeListWidgetsState extends State<HomeListWidgets> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TaskListCubit>().fetchTasks();
  }

  final List<Map<String, dynamic>> taskSections = [
    {
      "icon": const FaIcon(
        FontAwesomeIcons.inbox,
        color: Colors.blue,
      ),
      'title': 'Inbox',
      'route': Pages.inboxtask,
// Set the desired color for Inbox icon
    },
    {
      "icon": const FaIcon(
        FontAwesomeIcons.solidCalendarDays,
        color: Colors.green,
      ),
      'title': 'Today',
      'route': Pages.todaytask,
    },
    {
      "icon": const FaIcon(
        FontAwesomeIcons.calendarXmark,
        color: Colors.orange,
      ),
      'title': 'Upcoming',
      'route': Pages.upcomingtask,
      // Set the desired color for Upcoming icon
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Colors.grey,
          // ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(0),
          separatorBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(
                left: 50,
              ),
              child: Divider(),
            );
          },
          shrinkWrap: true,
          itemCount: taskSections.length,
          itemBuilder: (context, index) {
            final sections = taskSections[index];

            return ListTile(
              // Adjust vertical padding here
              leading: sections['icon'],
              minVerticalPadding: 0,
              title: Text(
                sections['title']!,
                style: AppTextStyles.bodySmall,
              ),
              trailing: sections['title'] == 'Inbox'
                  ? BlocBuilder<ActiveTaskCountCubit, ActiveTaskCountState>(
                      builder: (context, state) {
                        return Text(
                          '${state.activeTaskCount}',
                          style: AppTextStyles.bodySmall,
                        );
                      },
                    )
                  : null, // No trailing for other sections

              onTap: () {
                context.push(sections['route']!);
              },
            );
          },
        ),
      ),
    );
  }
}
