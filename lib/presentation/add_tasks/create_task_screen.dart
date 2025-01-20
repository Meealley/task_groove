// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/models/tastlist_status.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';
import 'package:task_groove/utils/button.dart';
import 'package:task_groove/utils/choice_chip.dart';
import 'package:task_groove/utils/custom_description_field.dart';
// import 'package:task_groove/utils/custom_description_field.dart';
import 'package:task_groove/utils/custom_textfield.dart';
import 'package:task_groove/utils/error_dialog.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController _titleController, _descriptionController;

  String? _title, _description;
  DateTime? _startDate, _stopDate;
  int _priority = 3;

  bool _loadWithProgress = false;
  bool _isReminderSet = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  // Function to format the date
  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'No date selected';
    }
    return DateFormat('EEEE d, yyyy').format(date);
  }

  // Function to pick the time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              bodyMedium: AppTextStyles.bodyText,
              bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.black),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: AppTextStyles.bodyText,
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextStyle: AppTextStyles.bodyText,
              dayPeriodTextStyle: AppTextStyles.bodyText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDate = focusedDay;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
  }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
      _loadWithProgress = true;
    });
    final form = _formKey.currentState;

    // if (form == null || !form.validate()) return;
    if (form == null || !form.validate()) {
      setState(() {
        _loadWithProgress = false; // Stop loading if validation fails
      });
      return;
    }

    form.save();

    // _loadWithProgress = !_loadWithProgress;
    DateTime? reminderDateTime;
    if (_isReminderSet) {
      // Set reminder for stop date if available, otherwise set for same day
      DateTime date = _rangeEnd ?? DateTime.now();
      reminderDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
    }

    final task = TaskModel(
      id: uuid.v4(),
      title: _titleController.text,
      description: _descriptionController.text,
      completed: false,
      priority: _priority,
      createdAt: DateTime.now(),
      startDateTime: _rangeStart,
      stopDateTime: _rangeEnd,
      reminder: reminderDateTime,
      // userId: auth.currentUser!.uid,
    );

    // context.read<TaskListCubit>().addTasks(task);
    try {
      await context.read<TaskListCubit>().addTasks(task);
      setState(() {
        _loadWithProgress = false;
      });
    } catch (e) {
      setState(() {
        _loadWithProgress = false;
      });
      // errorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create New Task",
          style: AppTextStyles.bodyTextBold,
        ),
      ),
      body: BlocConsumer<TaskListCubit, TaskListState>(
        listener: (context, state) {
          if (state.status == TaskListStatus.success) {
            context.pushReplacement(Pages.inboxtask);
          } else if (state.status == TaskListStatus.error) {
            errorDialog(context, state.error);
            _loadWithProgress = false;
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Calendar with range selection
                      TableCalendar(
                        headerStyle: HeaderStyle(
                          titleTextStyle: AppTextStyles.bodyText,
                        ),
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: AppTextStyles.bodyText,
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: AppTextStyles.bodySmall,
                        ),
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _selectedDate,
                        calendarFormat: _calendarFormat,
                        rangeStartDay: _rangeStart,
                        rangeEndDay: _rangeEnd,
                        rangeSelectionMode: _rangeSelectionMode,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDate, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDate = selectedDay;
                            _rangeSelectionMode =
                                RangeSelectionMode.toggledOn; // Reset mode
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onRangeSelected: _onRangeSelected,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Task Title",
                        style: AppTextStyles.bodyText,
                      ),
                      SizedBox(height: 1.5.h),
                      CustomTextField(
                        textInputType: TextInputType.text,
                        textEditingController: _titleController,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Title is required";
                          }

                          return null;
                        },
                        onSaved: (String? value) {
                          _title = value;
                        },
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Description",
                        style: AppTextStyles.bodyText,
                      ),
                      SizedBox(height: 1.h),

                      CustomDescriptionTextField(
                        textInputType: TextInputType.text,
                        textEditingController: _descriptionController,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Description is required";
                          }

                          return null;
                        },
                        onSaved: (String? value) {
                          _description = value;
                        },
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Text(
                        "Task Priority",
                        style: AppTextStyles.bodyText,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      PriorityChips(
                          initialPriority: 3,
                          onSelected: (priority) {
                            setState(() {
                              _priority = priority;
                            });
                          }),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _selectTime(context); // Select time
                            },
                            child: Text(
                              'Pick Time',
                              style: AppTextStyles.bodyText,
                            ),
                          ),
                          Text(
                            '🕐 Selected Time: ${_selectedTime.format(context)}',
                            style: AppTextStyles.bodyText,
                          ),
                        ],
                      ),

// Switch for reminder
                      SwitchListTile(
                        title:
                            Text("Set Reminder", style: AppTextStyles.bodyText),
                        value: _isReminderSet,
                        onChanged: (bool value) {
                          setState(() {
                            _isReminderSet = value;
                          });
                        },
                      ),

                      // SizedBox(height: 1.h),
                      // Task Period (Start and End Range)
                      Text(
                        "Task Period",
                        style: AppTextStyles.bodyGrey,
                      ),
                      SizedBox(height: 1.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.calendarDay,
                                color: AppColors.backgroundDark,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                _rangeStart != null
                                    ? _formatDate(_rangeStart)
                                    : 'No start date',
                                style: AppTextStyles.bodySmall,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.calendarCheck,
                                color: Colors.green,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                _rangeEnd != null
                                    ? _formatDate(_rangeEnd)
                                    : 'No end date',
                                style: AppTextStyles.bodySmall,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),

                      ButtonPress(
                        loadWithProgress: _loadWithProgress,
                        text: "Add Task",
                        onPressed: _loadWithProgress ? null : _submit,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
