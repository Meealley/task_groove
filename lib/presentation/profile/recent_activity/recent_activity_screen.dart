import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_groove/cubits/recent_activity/recent_activity_cubit.dart';
import 'package:task_groove/models/recent_activity_status.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/capitalize_text.dart';
import 'package:task_groove/utils/truncate_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentActivityScreen extends StatefulWidget {
  const RecentActivityScreen({super.key});

  @override
  State<RecentActivityScreen> createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends State<RecentActivityScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecentActivityCubit>().fetchAllActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recent Activity",
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
      ),
      body: BlocBuilder<RecentActivityCubit, RecentActivityState>(
        builder: (context, state) {
          if (state.recentActivityStatus == RecentActivityStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.recentAcitvities.isEmpty) {
            return Center(
              child: Text(
                'No recent activities found.',
                style: AppTextStyles.bodyText,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(0),
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: state.recentAcitvities.length,
            itemBuilder: (context, index) {
              final activity = state.recentAcitvities[index];

              return ListTile(
                minVerticalPadding: 0,
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 21,
                  child: CircleAvatar(
                    backgroundColor: (() {
                      switch (activity.action) {
                        case 'You created a task:':
                          return Colors.blue[200];
                        case 'You completed a task:':
                          return const Color.fromARGB(255, 189, 243, 191);
                        case 'You deleted a task':
                          return Colors.red[200];
                        case 'pointsIncreased':
                          return Colors.orange[200];
                        default:
                          return Colors.grey;
                      }
                    })(),
                    child: Builder(
                      builder: (context) {
                        switch (activity.action) {
                          case 'You created a task:':
                            return const FaIcon(
                              FontAwesomeIcons.circlePlus,
                              size: 20,
                              color: Colors.blue,
                            );
                          case 'You completed a task:':
                            return const FaIcon(
                              FontAwesomeIcons.circleCheck,
                              color: Colors.green,
                            );
                          case 'You deleted a task':
                            return const FaIcon(
                              FontAwesomeIcons.trash,
                              color: Colors.red,
                            );
                          case 'pointsIncreased':
                            return const FaIcon(FontAwesomeIcons.arrowUp);
                          default:
                            return const FaIcon(FontAwesomeIcons.shield);
                        }
                      },
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      capitalizeFirstLetter(activity.action),
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      truncateText(activity.taskTitle, 8),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                subtitle: Text(
                  timeago.format(activity.timestamp),
                  style: AppTextStyles.bodySmall,
                ),
                trailing: Text(
                  ' ${activity.pointsGained}',
                  style: AppTextStyles.bodySmall,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
