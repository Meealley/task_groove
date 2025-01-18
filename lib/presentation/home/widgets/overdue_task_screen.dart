import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_groove/cubits/overdue_task/overdue_task_cubit.dart';
import 'package:task_groove/models/overdue_task_status.dart';
import 'package:task_groove/routes/pages.dart';
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
    return DateFormat('EEE d, MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Overdue tasks",
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => context.goNamed(Pages.bottomNavbar),
          color: Colors.white,
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
          ),
        ),
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
                  return Dismissible(
                    key: Key(task.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        FontAwesomeIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      context.read<OverdueTaskCubit>().deleteTask(task);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Task ${task.title} deleted',
                          style: AppTextStyles.bodyText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        duration: const Duration(seconds: 2),
                      ));
                    },
                    child: Container(
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
                        onTap: () {
                          context.pushNamed(Pages.taskDescription,
                              pathParameters: {'id': task.id}, extra: task);
                        },
                        title: Text(
                          task.title,
                          style: AppTextStyles.bodyText,
                        ),
                        subtitle: Text(
                          task.stopDateTime != null
                              ? 'Due: ${_formatDate(task.stopDateTime)}' // Display stopDateTime if available
                              : 'Started: ${_formatDate(task.startDateTime)}', // Fallback to startDateTime if no stopDateTime
                          style: AppTextStyles.bodyText
                              .copyWith(color: Colors.red),
                        ),
                      ),
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
