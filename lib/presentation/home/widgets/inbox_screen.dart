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
  List<TaskModel> activeTasks = []; // List to hold active tasks
  List<TaskModel> completedTasks = []; // List to hold completed tasks
  bool showCompletedTasks =
      false; // To track if completed tasks should be shown
  final GlobalKey<AnimatedListState> _listKey =
      GlobalKey<AnimatedListState>(); // Key for AnimatedList
  final Duration animationDuration =
      const Duration(milliseconds: 300); // Duration for animations
  int _completedTasksVisibleCount =
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
        _completedTasksVisibleCount =
            completedTasks.length; // Set to full count
      } else {
        // Remove completed tasks with animation
        for (int i = completedTasks.length - 1; i >= 0; i--) {
          _listKey.currentState?.removeItem(i, (context, animation) {
            return _buildCompletedTaskItem(completedTasks[i], animation);
          });
        }
        _completedTasksVisibleCount = 0; // Set to full count
      }
    });
  }

  // Handle task completion status change
  // void _onTaskCompleted(TaskModel task) {
  //   setState(() {
  //     final updatedTask = task.copyWith(completed: !task.completed);

  //     if (updatedTask.completed) {
  //       // Task is marked as completed, move it to completedTasks list
  //       activeTasks.removeWhere((t) => t.id == task.id);
  //       completedTasks.add(updatedTask);

  //       // If showCompletedTasks is true, animate the addition of the task
  //       if (showCompletedTasks) {
  //         _listKey.currentState?.insertItem(completedTasks.length - 1);
  //       }
  //     } else {
  //       // Task is unmarked as completed, move it back to activeTasks list
  //       int completedTaskIndex =
  //           completedTasks.indexWhere((t) => t.id == task.id);
  //       if (completedTaskIndex != -1) {
  //         final removedTask = completedTasks.removeAt(completedTaskIndex);

  //         // If showCompletedTasks is true, animate the removal of the task
  //         if (showCompletedTasks) {
  //           _listKey.currentState?.removeItem(
  //             completedTaskIndex,
  //             (context, animation) =>
  //                 _buildCompletedTaskItem(removedTask, animation),
  //           );
  //         }

  //         // Add it back to the active task list
  //         activeTasks.add(updatedTask);
  //       }
  //     }

  //     // Update the task in the state management
  //     context.read<TaskListCubit>().updateTasks(updatedTask);
  //   });
  // }

  // void _onTaskCompleted(TaskModel task) {
  //   setState(() {
  //     final updatedTask = task.copyWith(completed: !task.completed);

  //     if (updatedTask.completed) {
  //       int activeTaskIndex = activeTasks.indexWhere((t) => t.id == task.id);
  //       if (activeTaskIndex != -1) {
  //         activeTasks.removeAt(activeTaskIndex);
  //         completedTasks.add(updatedTask);

  //         if (showCompletedTasks && _listKey.currentState != null) {
  //           _listKey.currentState?.insertItem(_completedTasksVisibleCount);
  //           _completedTasksVisibleCount++; // Increment the visible count
  //         }
  //       }
  //     } else {
  //       int completedTaskIndex =
  //           completedTasks.indexWhere((t) => t.id == task.id);
  //       if (completedTaskIndex != -1) {
  //         completedTasks.removeAt(completedTaskIndex);
  //         activeTasks.add(updatedTask);

  //         if (showCompletedTasks && _listKey.currentState != null) {
  //           _listKey.currentState?.removeItem(
  //             completedTaskIndex,
  //             (context, animation) => _buildCompletedTaskItem(task, animation),
  //           );
  //           _completedTasksVisibleCount--; // Decrement the visible count
  //         }
  //       }
  //     }

  //     context.read<TaskListCubit>().updateTasks(updatedTask);
  //   });
  // }

  void _onTaskCompleted(TaskModel task) {
    setState(() {
      final updatedTask = task.copyWith(completed: !task.completed);

      if (updatedTask.completed) {
        // Remove from activeTasks
        final activeIndex = activeTasks.indexWhere((t) => t.id == task.id);
        if (activeIndex != -1) {
          activeTasks.removeAt(activeIndex);
        }

        // Add to completedTasks and insert into AnimatedList if necessary
        completedTasks.add(updatedTask);
        if (showCompletedTasks && _listKey.currentState != null) {
          if (_completedTasksVisibleCount < completedTasks.length) {
            _listKey.currentState?.insertItem(completedTasks.length - 1);
            _completedTasksVisibleCount++;
          }
        }
      } else {
        // Remove from completedTasks and active AnimatedList
        final completedIndex =
            completedTasks.indexWhere((t) => t.id == task.id);
        if (completedIndex != -1) {
          completedTasks.removeAt(completedIndex);
          if (showCompletedTasks && _listKey.currentState != null) {
            if (_completedTasksVisibleCount > completedIndex) {
              _listKey.currentState?.removeItem(
                completedIndex,
                (context, animation) =>
                    _buildCompletedTaskItem(task, animation),
              );
              _completedTasksVisibleCount--;
            }
          }
        }

        // Add back to activeTasks
        activeTasks.add(updatedTask);
      }

      // Update the state in your cubit or state manager
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
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            elevation: 25,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            icon: const Icon(Icons.more_vert),
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

          if (activeTasks.isEmpty && completedTasks.isEmpty) {
            return Center(
              child: Text(
                'No tasks available, Please add a task. 📝',
                style: AppTextStyles.bodyText,
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
                // AnimatedList(
                //   key: _listKey,
                //   shrinkWrap: true,
                //   initialItemCount: activeTasks.length,
                //   itemBuilder: (context, index, animation) {
                //     return _buildTaskItem(activeTasks[index], animation);
                //   },
                // ),

                // Animated list for completed tasks
                if (completedTasks.isNotEmpty)
                  AnimatedList(
                    key: _listKey,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    initialItemCount:
                        showCompletedTasks ? completedTasks.length : 0,
                    itemBuilder: (context, index, animation) {
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
