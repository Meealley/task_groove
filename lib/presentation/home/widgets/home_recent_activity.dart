import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/cubits/recent_activity/recent_activity_cubit.dart';
import 'package:task_groove/routes/pages.dart';
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
  // ignore: must_call_super
  void initState() {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    top: 13,
                    left: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Activities",
                        style: AppTextStyles.bodyTextBold,
                      ),
                      GestureDetector(
                        onTap: () => context.push(Pages.recentActivity),
                        child: Text(
                          "View All",
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.grey,
                    );
                  },
                  shrinkWrap: true,
                  itemCount: state.recentAcitvities.length.clamp(0, 4),
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
                                return Colors
                                    .blue[200]; // Light green for created task
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
                                    color: Colors.white,
                                  );
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
