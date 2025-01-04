import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/task_list/task_list_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/utils/choice_chip.dart';
import 'package:task_groove/utils/custom_description_field.dart';
import 'package:task_groove/utils/custom_textfield.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late int _selectedPriority;
  DateTime? _startDateTime;
  DateTime? _stopDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _selectedPriority = widget.task.priority;
    _startDateTime = widget.task.startDateTime;
    _stopDateTime = widget.task.stopDateTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime? initialDate,
    required Function(DateTime) onDatePicked,
  }) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              bodyMedium:
                  AppTextStyles.bodyText, // Apply your custom style here
              bodyLarge: AppTextStyles.bodyText,
              titleLarge: AppTextStyles.bodyText,
              bodySmall: AppTextStyles.bodyText,
              labelLarge: AppTextStyles.bodyText,
              labelSmall: AppTextStyles.bodyText,
              displaySmall: AppTextStyles.bodySmall,
              headlineLarge: AppTextStyles.bodyTextBold.copyWith(
                fontSize: 28,
              ),
              // headlineSmall: AppTextStyles.bodySmall,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onDatePicked(pickedDate);
    }
  }

  void _saveTask() {
    final updatedTask = TaskModel(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      completed: widget.task.completed,
      priority: _selectedPriority,
      startDateTime: _startDateTime,
      stopDateTime: _stopDateTime,
      createdAt: widget.task.createdAt,
    );

    context.read<TaskListCubit>().updateTasks(updatedTask);
    context.goNamed(Pages.inboxtask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.goNamed(Pages.inboxtask),
          color: Colors.white,
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
          ),
        ),
        title: Text(
          'Edit Task',
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task Title",
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 1.h),
                CustomTextField(
                  textInputType: TextInputType.text,
                  textEditingController: _titleController,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Task Description",
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 1.h),
                CustomDescriptionTextField(
                  textInputType: TextInputType.text,
                  textEditingController: _descriptionController,
                ),
                SizedBox(height: 1.5.h),
                Text(
                  "Task Priority",
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 1.h),
                PriorityChips(
                  initialPriority: _selectedPriority,
                  onSelected: (priority) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                ),
                SizedBox(height: 2.h),
                Text(
                  "Start Date",
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 1.h),
                ListTile(
                  title: Text(
                    _startDateTime != null
                        ? DateFormat.yMMMd().format(_startDateTime!)
                        : "No Start Date Selected",
                    style: AppTextStyles.bodyText,
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(
                    initialDate: _startDateTime,
                    onDatePicked: (date) {
                      setState(() {
                        _startDateTime = date;
                      });
                    },
                  ),
                ),
                SizedBox(height: 1.5.h),
                Text(
                  "Stop Date",
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 1.h),
                ListTile(
                  title: Text(
                    _stopDateTime != null
                        ? DateFormat.yMMMd().format(_stopDateTime!)
                        : "No Stop Date Selected",
                    style: AppTextStyles.bodyText,
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(
                    initialDate: _stopDateTime,
                    onDatePicked: (date) {
                      setState(() {
                        _stopDateTime = date;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
