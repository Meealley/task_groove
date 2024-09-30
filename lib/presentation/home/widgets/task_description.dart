import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/theme/app_textstyle.dart';

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
    return DateFormat('EEEE d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                "Task title",
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
                    ),
                    // color: _selectedPriority == 3 ? Colors.white : Colors.black,
                  ),
                ),
                selected: widget.task.priority == widget.task.priority,
                selectedColor: Colors.green,
                // onSelected: (_) => _updatePriority(3),
              ),
            ],
          )
        ],
      ),
    );
  }
}
