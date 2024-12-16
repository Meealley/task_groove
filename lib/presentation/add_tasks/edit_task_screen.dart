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

  // int _priority = 3;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _selectedPriority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    // Implement the logic to save the edited task here
    // For example, you might want to update the task in your database

    // You can access the updated values with:
    final updatedTask = TaskModel(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      completed: widget.task.completed,
      priority: _selectedPriority,
      createdAt: widget.task.createdAt,
      // userId: auth.currentUser!.uid,
    );

    // Then navigate back or update your state as needed
    context.read<TaskListCubit>().updateTasks(updatedTask);
    context.goNamed(Pages.inboxtask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: AppTextStyles.headingBold,
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
                  style: AppTextStyles.bodyText,
                ),
                SizedBox(
                  height: 1.h,
                ),
                CustomTextField(
                    textInputType: TextInputType.text,
                    textEditingController: _titleController),
                SizedBox(height: 2.h),
                Text(
                  "Task Description",
                  style: AppTextStyles.bodyText,
                ),
                SizedBox(
                  height: 1.h,
                ),
                CustomDescriptionTextField(
                  textInputType: TextInputType.text,
                  textEditingController: _descriptionController,
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
                  initialPriority: _selectedPriority,
                  onSelected: (priority) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
