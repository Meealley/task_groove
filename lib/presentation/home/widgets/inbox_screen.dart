import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/models/tastlist_status.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks when the InboxScreen is loaded
    context.read<TaskListCubit>().fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inbox",
          style: AppTextStyles.bodyText,
        ),
      ),
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          if (state.status == TaskListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == TaskListStatus.error) {
            return Center(
              child: Text(
                'Error: ${state.error.message}',
                style: AppTextStyles.bodySmall,
              ),
            );
          } else if (state.status == TaskListStatus.success) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Text(
                  "No tasks available",
                  style: AppTextStyles.bodySmall,
                ),
              );
            }
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title, style: AppTextStyles.bodyText),
                  subtitle:
                      Text(task.description, style: AppTextStyles.bodySmall),
                  trailing: Text(
                    'Priority: ${task.priority}',
                    style: AppTextStyles.bodyItems,
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink(); // Default case
        },
      ),
    );
  }
}
