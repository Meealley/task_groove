import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/models/tastlist_status.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/truncate_text.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<TaskModel> localTasks = [];

  @override
  void initState() {
    super.initState();
    context.read<TaskListCubit>().fetchTasks(); // Fetch tasks when screen loads
  }

  void _onTaskCompleted(TaskModel task) {
    // Toggle the completed status locally
    setState(() {
      final updatedTask = task.copyWith(completed: !task.completed);
      localTasks =
          localTasks.map((t) => t.id == task.id ? updatedTask : t).toList();
    });

    // Update the task in the backend without triggering a UI refresh
    context
        .read<TaskListCubit>()
        .updateTasks(task.copyWith(completed: !task.completed));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inbox",
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.backgroundDark,
        leading: IconButton(
          onPressed: () => context.goNamed(Pages.bottomNavbar),
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
          ),
        ),
        actions: [
          Platform.isIOS
              ? IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        // title: const Text('Options'),
                        actions: <CupertinoActionSheetAction>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              // Handle showing completed tasks
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Show Completed Tasks',
                              style: AppTextStyles.bodyText,
                            ),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              context
                                  .read<TaskListCubit>()
                                  .sortTasksByPriority();
                              context.pop();
                            },
                            child: Text(
                              'Sort by Priority',
                              style: AppTextStyles.bodyText,
                            ),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              // Handle sorting by date
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Sort by Date',
                              style: AppTextStyles.bodyText,
                            ),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.bodyText,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : PopupMenuButton<String>(
                  color: Colors.white,
                  elevation: 25,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  icon:
                      const Icon(Icons.more_vert), // Android-specific menu icon
                  onSelected: (String value) {
                    switch (value) {
                      case 'Show Completed Tasks':
                        // Handle showing completed tasks
                        break;
                      case 'Sort by Priority':
                        // Handle sorting by priority
                        break;
                      case 'Sort by Date':
                        // Handle sorting by date
                        break;
                    }
                  },
                  offset: const Offset(0, kToolbarHeight),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'Show Completed Tasks',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Show Completed Tasks',
                              style: AppTextStyles.bodyText,
                            ),
                            const FaIcon(FontAwesomeIcons.circleCheck,
                                size: 20), // Trailing icon
                          ],
                        ),
                      ),
                      const PopupMenuDivider(), // Divider after the first item
                      PopupMenuItem(
                          value: 'Sort by Priority',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sort by Priority',
                                style: AppTextStyles.bodyText,
                              ),
                              const FaIcon(FontAwesomeIcons.creativeCommons,
                                  size: 20), // Trailing icon
                            ],
                          ),
                          onTap: () {
                            context.read<TaskListCubit>().sortTasksByPriority();
                          }),
                      const PopupMenuDivider(), // Divider after the second item
                      PopupMenuItem(
                        value: 'Sort by Date',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sort by Date',
                              style: AppTextStyles.bodyText,
                            ),
                            const Icon(Icons.calendar_today,
                                size: 20), // Trailing icon
                          ],
                        ),
                      ),
                    ];
                  },
                ),
        ],
      ),
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          if (state.status == TaskListStatus.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state.tasks.isEmpty) {
            return Center(
              child: Text(
                'No task available, Please add a task. 📝',
                style: AppTextStyles.bodyText,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: task.priority == 1
                        ? Colors.red.shade300
                        : task.priority == 2
                            ? const Color.fromRGBO(220, 164, 124, 57)
                            : const Color.fromRGBO(156, 169, 134, 57),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.completed,
                      shape: const CircleBorder(),
                      checkColor: Colors.white,
                      focusColor: Colors.green,
                      onChanged: (_) {
                        _onTaskCompleted(task); // Toggle task completion
                      },
                    ),
                    title: Text(task.title, style: AppTextStyles.bodyText),
                    subtitle: Text(truncateText(task.description, 30),
                        style: AppTextStyles.bodySmall),
                    trailing: Chip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      label: Text(
                        task.priority == 1
                            ? "High"
                            : task.priority == 2
                                ? "Medium"
                                : "Low",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: task.priority == 1
                              ? Colors.red.shade300
                              : task.priority == 2
                                  ? const Color.fromRGBO(220, 164, 124, 57)
                                  : const Color.fromRGBO(156, 169, 134, 57),
                        ),
                      ),
                    ),
                    onTap: () {
                      context.pushNamed(
                        Pages.taskDescription,
                        pathParameters: {
                          'id': task.id,
                        },
                        extra: task,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
