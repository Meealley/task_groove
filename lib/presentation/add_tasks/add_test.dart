// class _CreateTaskScreenState extends State<CreateTaskScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
//   late TextEditingController _titleController, _descriptionController;

//   String? _title, _description;
//   DateTime? _startDate, _stopDate;
//   int _priority = 3;
//   bool _loadWithProgress = false;
//   bool _isReminderSet = false; // New boolean to manage the switch
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay.now();

//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   CalendarFormat _calendarFormat = CalendarFormat.week;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

//   // Function to format the date
//   String _formatDate(DateTime? date) {
//     if (date == null) {
//       return 'No date selected';
//     }
//     return DateFormat('EEEE d, yyyy').format(date);
//   }

//   // Function to pick the time
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//     );

//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController();
//     _descriptionController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _titleController.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     _autovalidateMode = AutovalidateMode.always;
//     final form = _formKey.currentState;

//     if (form == null || !form.validate()) return;
//     form.save();

//     _loadWithProgress = !_loadWithProgress;
    
//     DateTime? reminderDateTime;
//     if (_isReminderSet) {
//       // Set reminder for stop date if available, otherwise set for same day
//       DateTime date = _rangeEnd ?? DateTime.now();
//       reminderDateTime = DateTime(
//         date.year,
//         date.month,
//         date.day,
//         _selectedTime.hour,
//         _selectedTime.minute,
//       );
//     }

//     final task = TaskModel(
//       id: uuid.v4(),
//       title: _titleController.text,
//       description: _descriptionController.text,
//       completed: false,
//       priority: _priority,
//       createdAt: DateTime.now(),
//       startDateTime: _rangeStart,
//       stopDateTime: _rangeEnd,
//       reminderTime: reminderDateTime, // Add the reminder time
//     );

//     context.read<TaskListCubit>().addTasks(task);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Create New Task",
//           style: AppTextStyles.bodyTextBold,
//         ),
//       ),
//       body: BlocConsumer<TaskListCubit, TaskListState>(
//         listener: (context, state) {
//           if (state.status == TaskListStatus.success) {
//             context.pushReplacement(Pages.inboxtask);
//           } else if (state.status == TaskListStatus.error) {
//             errorDialog(context, state.error);
//             _loadWithProgress = false;
//           }
//         },
//         builder: (context, state) {
//           return GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: ListView(
//               padding: const EdgeInsets.all(15),
//               children: [
//                 Form(
//                   key: _formKey,
//                   autovalidateMode: _autovalidateMode,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Calendar with range selection
//                       TableCalendar(
//                         // Calendar settings
//                         // (existing code here)
//                       ),
//                       const SizedBox(height: 20),
                      
//                       // Title
//                       Text("Task Title", style: AppTextStyles.bodyText),
//                       SizedBox(height: 1.5.h),
//                       CustomTextField(
//                         textInputType: TextInputType.text,
//                         textEditingController: _titleController,
//                         // (existing code here)
//                       ),
                      
//                       SizedBox(height: 2.h),
                      
//                       // Description
//                       Text("Description", style: AppTextStyles.bodyText),
//                       SizedBox(height: 1.h),
//                       CustomDescriptionTextField(
//                         // (existing code here)
//                       ),

//                       // Priority Chips
//                       SizedBox(height: 1.5.h),
//                       Text("Task Priority", style: AppTextStyles.bodyText),
//                       SizedBox(height: 1.h),
//                       PriorityChips(onSelected: (priority) {
//                         setState(() {
//                           _priority = priority;
//                         });
//                       }),
                      
//                       const SizedBox(height: 20),
                      
//                       // Pick Time button
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               _selectTime(context);
//                             },
//                             child: Text(
//                               'Pick Time',
//                               style: AppTextStyles.bodyText,
//                             ),
//                           ),
//                           Text(
//                             '🕐 Selected Time: ${_selectedTime.format(context)}',
//                             style: AppTextStyles.bodyText,
//                           ),
//                         ],
//                       ),
                      
//                       // Switch for reminder
//                       SwitchListTile(
//                         title: Text("Set Reminder", style: AppTextStyles.bodyText),
//                         value: _isReminderSet,
//                         onChanged: (bool value) {
//                           setState(() {
//                             _isReminderSet = value;
//                           });
//                         },
//                       ),
                      
//                       // Task Period (Start and End Range)
//                       Text("Task Period", style: AppTextStyles.bodyGrey),
//                       SizedBox(height: 1.5.h),
//                       // (existing date range picker code)

//                       SizedBox(height: 8.h),

//                       // Add Task Button
//                       ButtonPress(
//                         loadWithProgress: _loadWithProgress,
//                         text: "Add Task",
//                         onPressed: _submit,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
