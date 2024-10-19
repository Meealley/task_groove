import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/models/tastlist_status.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:intl/intl.dart';

class UpcomingTaskScreen extends StatefulWidget {
  const UpcomingTaskScreen({super.key});

  @override
  _UpcomingTaskScreenState createState() => _UpcomingTaskScreenState();
}

class _UpcomingTaskScreenState extends State<UpcomingTaskScreen> {
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen is initialized
    context.read<TaskListCubit>().fetchTasks();
  }

  void _onTaskCompleted(TaskModel task) {
    // Toggle the completed status locally
    setState(() {
      final updatedTask = task.copyWith(completed: !task.completed);
      context.read<TaskListCubit>().updateTasks(updatedTask);
    });
  }

  String getDayLabel(DateTime date) {
    final now = DateTime.now();
    if (isSameDay(date, now)) {
      return 'Today';
    } else if (isSameDay(date, now.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else if (isSameDay(date, now.add(const Duration(days: 2)))) {
      return 'Next Tomorrow';
    } else {
      return DateFormat.yMMMd()
          .format(date); // Return formatted date for other days
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upcoming Tasks',
          style: AppTextStyles.headingBold,
        ),
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            calendarStyle: CalendarStyle(
              defaultTextStyle: AppTextStyles.bodyText,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppTextStyles.bodySmall,
            ),
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: selectedDay,
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
              });
            },
            headerStyle: const HeaderStyle(formatButtonVisible: false),
          ),

          // Display Day Label (Today, Tomorrow, Next Tomorrow)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              getDayLabel(selectedDay),
              style: AppTextStyles.bodyTextBold,
            ),
          ),

          // BlocBuilder to listen to TaskListCubit
          Expanded(
            child: BlocBuilder<TaskListCubit, TaskListState>(
              builder: (context, state) {
                if (state.status == TaskListStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == TaskListStatus.error) {
                  return Center(
                    child: Text(
                      'Error loading tasks: ${state.error.message}',
                      style: AppTextStyles.bodyText,
                    ),
                  );
                } else if (state.status == TaskListStatus.success) {
                  // Filter tasks based on the selected day
                  final tasksForSelectedDay = state.tasks.where((task) {
                    return task.startDateTime != null &&
                        isSameDay(task.startDateTime!, selectedDay);
                  }).toList();

                  if (tasksForSelectedDay.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks for ${DateFormat.yMMMd().format(selectedDay)}',
                        style: AppTextStyles.bodyText,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasksForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final task = tasksForSelectedDay[index];
                      return ListTile(
                        title: Text(task.title, style: AppTextStyles.bodyText),
                        subtitle: Text(
                          task.description,
                          style: AppTextStyles.bodySmall,
                        ),
                        trailing: Text(
                          DateFormat.jm().format(task.startDateTime!),
                          style: AppTextStyles.bodySmall,
                        ),
                        onTap: () {
                          context.pushNamed(
                            Pages.taskDescription,
                            pathParameters: {'id': task.id},
                            extra: task,
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
