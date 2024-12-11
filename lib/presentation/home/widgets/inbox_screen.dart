// import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
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
  List<TaskModel> activeTasks = []; // List to hold active tasks
  List<TaskModel> completedTasks = []; // List to hold completed tasks
  bool showCompletedTasks =
      false; // To track if completed tasks should be shown
  final GlobalKey<AnimatedListState> _listKey =
      GlobalKey<AnimatedListState>(); // Key for AnimatedList
  final Duration animationDuration =
      const Duration(milliseconds: 300); // Duration for animations
  final int _completedTasksVisibleCount =
      0; // Tracks the number of completed tasks shown in the AnimatedList.

  @override
  void initState() {
    super.initState();
    context.read<TaskListCubit>().fetchTasks(); // Fetch tasks when screen loads

    Future.delayed(const Duration(milliseconds: 300), () {
      context
          .read<TaskListCubit>()
          .fetchCompletedTasks(); // Fetch completed tasks
    });
  }

  // Toggle show/hide completed tasks
  void _toggleCompletedTasks() {
    setState(() {
      showCompletedTasks = !showCompletedTasks;
      if (showCompletedTasks) {
        // Insert completed tasks with animation
        for (int i = 0; i < completedTasks.length; i++) {
          _listKey.currentState?.insertItem(i);
        }
        // _completedTasksVisibleCount =
        //     completedTasks.length; // Set to full count
      } else {
        // Remove completed tasks with animation
        for (int i = completedTasks.length - 1; i >= 0; i--) {
          _listKey.currentState?.removeItem(i, (context, animation) {
            return _buildCompletedTaskItem(completedTasks[i], animation);
          });
        }
        // _completedTasksVisibleCount = 0; // Set to full count
      }
    });
  }

  void _onTaskCompleted(TaskModel task) {
    setState(() {
      final updatedTask = task.copyWith(
        completed: !task.completed,
        completionDate: !task.completed ? DateTime.now() : null,
      );

      if (updatedTask.completed) {
        // Move to completed tasks
        activeTasks.removeWhere((t) => t.id == task.id);
        completedTasks.add(updatedTask);

        // If showing completed tasks, animate addition
        if (showCompletedTasks) {
          _listKey.currentState?.insertItem(completedTasks.length - 1);
        }
      } else {
        // Move back to active tasks
        final completedIndex =
            completedTasks.indexWhere((t) => t.id == task.id);
        if (completedIndex != -1) {
          final removedTask = completedTasks.removeAt(completedIndex);

          if (showCompletedTasks) {
            _listKey.currentState?.removeItem(
              completedIndex,
              (context, animation) =>
                  _buildCompletedTaskItem(removedTask, animation),
            );
          }
        }
        activeTasks.add(updatedTask);
      }

      // Update state in the cubit
      context.read<TaskListCubit>().updateTasks(updatedTask);
    });
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
          color: Colors.white,
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            elevation: 25,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (String value) {
              switch (value) {
                case 'Show Completed Tasks':
                  _toggleCompletedTasks(); // Toggle showing completed tasks
                  break;
                case 'Sort by Priority':
                  context.read<TaskListCubit>().sortTasksByPriority();
                  break;
                case 'Sort by Date':
                  // Handle sorting by date
                  context.read<TaskListCubit>().sortTasksByDueDate();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Show Completed Tasks',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        showCompletedTasks
                            ? 'Hide Completed Tasks'
                            : 'Show Completed Tasks',
                        style: AppTextStyles.bodyText,
                      ),
                      const FaIcon(FontAwesomeIcons.circleCheck, size: 20),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'Sort by Priority',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sort by Priority', style: AppTextStyles.bodyText),
                      const FaIcon(FontAwesomeIcons.creativeCommons, size: 20),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'Sort by Date',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sort by Date', style: AppTextStyles.bodyText),
                      const Icon(Icons.calendar_today, size: 20),
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

          // Update the local task lists from the state
          activeTasks = state.tasks.where((task) => !task.completed).toList();
          completedTasks = state.tasks.where((task) => task.completed).toList();

          // Checks if there are no tasks created at all
          if (state.tasks.isEmpty) {
            return Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/empty_file.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Text(
                    'No tasks available, Please add a task. 📝',
                    style: AppTextStyles.bodyText,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                  onTap: () {
                    context.push(Pages.createTask);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      "Add Task",
                      style:
                          AppTextStyles.bodyText.copyWith(color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          }

// Check if all tasks have been completed
          if (activeTasks.isEmpty &&
              completedTasks.isNotEmpty &&
              !showCompletedTasks) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/congratulations.png', // Replace with a congratulatory image
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '🎉 Congratulations!',
                      style: AppTextStyles.heading.copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You have completed all your tasks for today. Keep up the great work!',
                      style: AppTextStyles.bodyText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        context.push(Pages.createTask);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Add More Tasks",
                          style: AppTextStyles.bodyText
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                // Display active tasks
                ...activeTasks.map((task) {
                  return _buildTaskItem(task);
                }),

                // Animated list for completed tasks
                if (completedTasks.isNotEmpty && showCompletedTasks)
                  AnimatedList(
                    key: _listKey,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    initialItemCount:
                        showCompletedTasks ? completedTasks.length : 0,
                    itemBuilder: (context, index, animation) {
                      if (index < 0 || index >= completedTasks.length) {
                        // Ensure we don't try to access an invalid index
                        return const SizedBox.shrink();
                      }
                      return _buildCompletedTaskItem(
                          completedTasks[index], animation);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget to build each completed task with animation
  Widget _buildCompletedTaskItem(TaskModel task, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
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
            subtitle: Text(
              truncateText(task.description, 30),
              style: AppTextStyles.bodySmall,
            ),
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
                pathParameters: {'id': task.id},
                extra: task,
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget to build each active task
  Widget _buildTaskItem(TaskModel task) {
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
        subtitle: Text(
          truncateText(task.description, 30),
          style: AppTextStyles.bodySmall,
        ),
        trailing: Chip(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
            pathParameters: {'id': task.id},
            extra: task,
          );
        },
      ),
    );
  }
}
