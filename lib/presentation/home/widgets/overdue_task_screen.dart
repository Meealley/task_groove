import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_groove/cubits/overdue_task/overdue_task_cubit.dart';
import 'package:task_groove/models/overdue_task_status.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class OverdueTaskScreen extends StatefulWidget {
  const OverdueTaskScreen({super.key});

  @override
  State<OverdueTaskScreen> createState() => _OverdueTaskScreenState();
}

class _OverdueTaskScreenState extends State<OverdueTaskScreen> {
  @override
  void initState() {
    super.initState();

    // Trigger fetch overdue tasks on screen load
    context.read<OverdueTaskCubit>().fetchOverdueTasks();
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'No date selected';
    }
    return DateFormat('EEEE d, yyyy').format(date);
  }

// TODO: PROVIDE THE BACKGROUND COLOR FOR THIS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Overdue tasks",
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        // backgroundColor: AppColors.backgroundDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<OverdueTaskCubit, OverdueTaskState>(
          builder: (context, state) {
            if (state.status == OverdueTaskStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == OverdueTaskStatus.error) {
              return Center(
                child: Text(state.error.message),
              );
            } else if (state.status == OverdueTaskStatus.success) {
              if (state.tasks.isEmpty) {
                return Center(
                  child: Text(
                    "No overdue tasks found. 👍🏽",
                    style: AppTextStyles.bodyText,
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return ListTile(
                    title: Text(
                      task.title,
                      style: AppTextStyles.bodyText,
                    ),
                    subtitle: Text(
                      task.stopDateTime != null
                          ? 'Due: ${_formatDate(task.stopDateTime)}' // Display stopDateTime if available
                          : 'Started: ${_formatDate(task.startDateTime)}', // Fallback to startDateTime if no stopDateTime
                      style: AppTextStyles.bodyText.copyWith(color: Colors.red),
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
