import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class TaskDescriptionScreen extends StatefulWidget {
  final TaskModel task;
  const TaskDescriptionScreen({super.key, required this.task});

  @override
  State<TaskDescriptionScreen> createState() => _TaskDescriptionScreenState();
}

class _TaskDescriptionScreenState extends State<TaskDescriptionScreen> {
  // Function to format the date
  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'No date selected';
    }
    return DateFormat('EEE d, MMM yyyy').format(date);
  }

  Future<void> _showDeleteTaskDialog() async {
    final shouldDeletetask = await showDialog<bool>(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          // Use CupertinoAlertDialog for iOS
          return CupertinoAlertDialog(
            title: Text(
              "Delete Task ",
              style: AppTextStyles.bodyTextBold,
            ),
            content: Text(
              "Are you sure you want to delete this task 🤔?  \nThis action cannot be undone.",
              style: AppTextStyles.bodySmall,
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  context.pop(); // Dismiss dialog
                },
                child: Text(
                  "Cancel",
                  style: AppTextStyles.bodyText,
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  context.pop(true); // Confirm delete
                },
                isDestructiveAction: true,
                child: Text(
                  "Delete",
                  style: AppTextStyles.bodyText,
                ),
              ),
            ],
          );
        } else {
          // Use AlertDialog for Android and other platforms
          return AlertDialog(
            title: Text(
              "Delete Task ",
              style: AppTextStyles.bodyTextBold,
            ),
            content: Text(
              "Are you sure you want to delete this task 🤔?  \nThis action cannot be undone.",
              style: AppTextStyles.bodySmall,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss dialog
                },
                child: Text(
                  "Cancel",
                  style: AppTextStyles.bodyText,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirm delete
                },
                child: Text(
                  "Delete",
                  style: AppTextStyles.bodyText,
                ),
              ),
            ],
          );
        }
      },
    );

    // If delete if user confirmed delete
    if (shouldDeletetask ?? false) {
      context.read<TaskListCubit>().deleteTasks(widget.task);
      context.read<TaskListCubit>().fetchTasks();
      context.goNamed(Pages.inboxtask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          color: Colors.white,
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        children: [
          SizedBox(
            height: 6.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Task title",
                        style: AppTextStyles.bodyGrey,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        widget.task.title,
                        style: AppTextStyles.bodyText,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Task Description",
                style: AppTextStyles.bodyGrey,
              ),
              Text(
                widget.task.description,
                style: AppTextStyles.bodyText,
              ),
              SizedBox(
                height: 4.h,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date",
                          style: AppTextStyles.bodyText,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.calendarDay,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              _formatDate(widget.task.startDateTime),
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stop Date",
                          style: AppTextStyles.bodyText,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.calendarXmark,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              _formatDate(widget.task.stopDateTime),
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Task Priority",
                style: AppTextStyles.bodyGrey,
              ),
              ChoiceChip(
                showCheckmark: false,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.sp)),
                label: Text(
                  widget.task.priority == 1
                      ? "High"
                      : widget.task.priority == 2
                          ? "Medium"
                          : "Low",
                  style: GoogleFonts.manrope(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                selected: widget.task.priority == widget.task.priority,
                selectedColor: widget.task.priority == 1
                    ? Colors.red
                    : widget.task.priority == 2
                        ? Colors.orange
                        : Colors.green,
              ),
              SizedBox(
                height: 3.h,
              ),

              SizedBox(
                height: 45,
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.backgroundDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                  onPressed: () {
                    context.pushReplacement(
                      Pages.editTask,
                      extra: widget.task,
                    );
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.penToSquare,
                    color: Colors.white,
                    size: 17,
                  ),
                  label: Text(
                    "Edit task",
                    style: AppTextStyles.textWhite,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Delete task Button
              SizedBox(
                height: 45,
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.backgroundDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                  onPressed: () async {
                    await _showDeleteTaskDialog(); // Use the platform-specific dialog here
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                    size: 17,
                  ),
                  label: Text(
                    "Delete task",
                    style: AppTextStyles.textWhite,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
