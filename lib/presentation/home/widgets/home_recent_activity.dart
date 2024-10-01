import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_groove/cubits/recent_activity/recent_activity_cubit.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/capitalize_text.dart';
import 'package:task_groove/utils/truncate_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeRecentActivity extends StatefulWidget {
  const HomeRecentActivity({super.key});

  @override
  State<HomeRecentActivity> createState() => _HomeRecentActivityState();
}

class _HomeRecentActivityState extends State<HomeRecentActivity> {
  @override
  void initState() {
    // TODO: implement initState

    context.read<RecentActivityCubit>().fetchRecentActivity();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentActivityCubit, RecentActivityState>(
      builder: (context, state) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Recent Activities",
                    style: AppTextStyles.bodyTextBold,
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  shrinkWrap: true,
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
                                return const Color.fromARGB(255, 189, 243,
                                    191); // Light green for created task
                              case 'updated':
                                return Colors
                                    .blue[200]; // Light blue for updated task
                              case 'deleted':
                                return Colors
                                    .red[200]; // Light red for deleted task
                              case 'pointsIncreased':
                                return Colors.orange[
                                    200]; // Light orange for points increased
                              default:
                                return Colors.grey; // Default background color
                            }
                          })(),
                          child: Builder(
                            builder: (context) {
                              switch (activity.action) {
                                case 'You created a task:':
                                  return const FaIcon(
                                    FontAwesomeIcons.circlePlus,
                                    size: 20,
                                    color: Colors.green,
                                  );
                                case 'updated':
                                  return const FaIcon(FontAwesomeIcons.pen);
                                case 'deleted':
                                  return const FaIcon(FontAwesomeIcons.trash);
                                case 'pointsIncreased':
                                  return const FaIcon(FontAwesomeIcons.arrowUp);
                                default:
                                  return const FaIcon(
                                      FontAwesomeIcons.shield); // Default icon
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
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            truncateText(activity.taskTitle, 13),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
