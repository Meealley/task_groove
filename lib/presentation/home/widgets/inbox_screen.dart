import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/models/tastlist_status.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/truncate_text.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<TaskModel> localTasks = [];
  TaskListStatus taskListStatus = TaskListStatus.loading;

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the InboxScreen is loaded and cache locally
    _fetchAndCacheTasks();
  }

  void _fetchAndCacheTasks() {
    final cubit = context.read<TaskListCubit>();
    cubit.fetchTasks().then((_) {
      setState(() {
        localTasks = cubit.state.tasks;
        taskListStatus = cubit.state.status!;
      });
    });
  }

  void _onTaskCompleted(TaskModel task) {
    // Toggle the completed status locally
    setState(() {
      final updatedTask = task.copyWith(completed: !task.completed);
      localTasks =
          localTasks.map((t) => t.id == task.id ? updatedTask : t).toList();

      // Call the cubit to update the task in the backend
      context.read<TaskListCubit>().updateTasks(updatedTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inbox",
          style: AppTextStyles.headingBold,
        ),
      ),
      body: taskListStatus == TaskListStatus.loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : localTasks.isEmpty
              ? Center(
                  child: Text(
                  'No task available, Please add task. 📝',
                  style: AppTextStyles.bodyText,
                ))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: localTasks.length,
                    itemBuilder: (context, index) {
                      final task = localTasks[index];
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
                          title:
                              Text(task.title, style: AppTextStyles.bodyText),
                          subtitle: Text(truncateText(task.description, 12),
                              style: AppTextStyles.bodySmall),
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
                                        ? const Color.fromRGBO(
                                            220, 164, 124, 57)
                                        : const Color.fromRGBO(
                                            156, 169, 134, 57),
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
                ),
    );
  }
}
