import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/cubits/today_task/today_task_cubit.dart';
import 'package:task_groove/models/tastlist_status.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/models/task_model.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({super.key});

  @override
  State<TodayTaskScreen> createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize fetching of today's tasks
    context.read<TodayTaskCubit>().initialize();
  }

  // Toggle task completion status
  void _onTaskCompleted(TaskModel task) {
    final updatedTask = task.copyWith(completed: !task.completed);
    context.read<TaskListCubit>().updateTasks(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today's Tasks",
          style: AppTextStyles.bodyText,
        ),
      ),
      body: BlocBuilder<TodayTaskCubit, TodayTaskState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.tasks.isEmpty) {
            return Center(
              child: Text(
                "No tasks for today",
                style: AppTextStyles.bodySmall,
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
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                      color: task.priority == 1
                          ? Colors.red.shade300
                          : task.priority == 2
                              ? const Color.fromRGBO(220, 164, 124, 57)
                              : const Color.fromRGBO(156, 169, 134, 57),
                      borderRadius: BorderRadius.circular(13)),
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
                    subtitle:
                        Text(task.description, style: AppTextStyles.bodySmall),
                    trailing: Chip(
                      // padding: const EdgeInsets.symmetric(horizontal: 20),
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
