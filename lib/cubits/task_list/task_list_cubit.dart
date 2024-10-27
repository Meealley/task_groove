import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/models/tastlist_status.dart';
import 'package:task_groove/repository/push_notification_repository.dart';
import 'package:task_groove/repository/task_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

part 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  final TaskRepository taskRepository;
  final PushNotificationRepository pushNotificationRepository;

  TaskListCubit(
      {required this.taskRepository, required this.pushNotificationRepository})
      : super(TaskListState.initial());

  // Fetch Task from TaskRepository
  Future<void> fetchTasks() async {
    emit(state.copyWith(status: TaskListStatus.loading));

    try {
      List<TaskModel> tasks = await taskRepository.fetchTasks();
      emit(
        state.copyWith(
          tasks: tasks,
          status: TaskListStatus.success,
        ),
      );
      print(tasks);
    } catch (e) {
      emit(
        state.copyWith(
          error: CustomError(message: e.toString()),
          status: TaskListStatus.error,
        ),
      );
    }
  }

  // Add tasks
  Future<void> addTasks(TaskModel task) async {
    emit(state.copyWith(status: TaskListStatus.loading));
    try {
      await taskRepository.addTask(task);
      final updatedTasks = List<TaskModel>.from(state.tasks)..add(task);
      emit(state.copyWith(tasks: updatedTasks, status: TaskListStatus.success));
      log(updatedTasks.toString());

// Schedule a notification based on the reminder or startDateTime
      if (task.reminder != null || task.startDateTime != null) {
        _scheduleTaskNotification(task);
      }
    } catch (e) {
      emit(state.copyWith(
        status: TaskListStatus.error,
        error: CustomError(message: e.toString()),
      ));
    }
  }

// Update tasks
  Future<void> updateTasks(TaskModel task) async {
    try {
      await taskRepository.updateTask(task);
      final updatedTasks =
          state.tasks.map((t) => t.id == task.id ? task : t).toList();
      emit(state.copyWith(tasks: updatedTasks, status: TaskListStatus.success));

      // Reschedule notification if needed
      if (task.startDateTime != null) {
        _scheduleTaskNotification(task);
      }
    } catch (e) {
      emit(state.copyWith(
        status: TaskListStatus.error,
        error: CustomError(message: e.toString()),
      ));
    }
  }

  // Delete Tasks
  Future<void> deleteTasks(TaskModel task) async {
    emit(state.copyWith(status: TaskListStatus.loading));

    try {
      await taskRepository.deleteTask(task);
      final updatedTasks = state.tasks.where((t) => t.id != task.id).toList();
      emit(state.copyWith(
        tasks: updatedTasks,
        status: TaskListStatus.success,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskListStatus.error,
          error: CustomError(message: e.toString()),
        ),
      );
    }
  }

  // Helper function to schedule task notifications
  void _scheduleTaskNotification(TaskModel task) {
    final now = DateTime.now();

    if (task.reminder != null) {
      final reminderTime = task.reminder!;

      // Schedule notification 30 minutes before the reminder time
      final notificationTimeBeforeReminder =
          reminderTime.subtract(const Duration(minutes: 30));

      if (notificationTimeBeforeReminder.isAfter(now)) {
        final durationUntilNotificationBeforeReminder =
            notificationTimeBeforeReminder.difference(now);
        Timer(durationUntilNotificationBeforeReminder, () {
          _sendNotification(task, "Task reminder: 30 minutes left");
        });
      }

      // Schedule notification at exact reminder time
      if (reminderTime.isAfter(now)) {
        final durationUntilReminder = reminderTime.difference(now);
        Timer(durationUntilReminder, () {
          _sendNotification(task, "Task reminder: Time to start the task!");
        });
      }
    } else if (task.startDateTime != null) {
      // If no reminder, schedule based on startDateTime
      final dueDateTime = task.startDateTime!;

      // Schedule notification 30 minutes before due
      final notificationTimeBeforeDue =
          dueDateTime.subtract(const Duration(minutes: 30));
      if (notificationTimeBeforeDue.isAfter(now)) {
        final durationUntilNotificationBeforeDue =
            notificationTimeBeforeDue.difference(now);
        Timer(durationUntilNotificationBeforeDue, () {
          _sendNotification(task, "Task is due in 30 minutes");
        });
      }

      // Schedule notification at exact due time
      if (dueDateTime.isAfter(now)) {
        final durationUntilDue = dueDateTime.difference(now);
        Timer(durationUntilDue, () {
          _sendNotification(task, "Task is due now");
        });
      }
    }
  }

  // Method to send notification using PushNotificationRepository
  Future<void> _sendNotification(TaskModel task, String body) async {
    try {
      final fcmToken = await pushNotificationRepository.getFcmToken();
      if (fcmToken != null) {
        await pushNotificationRepository.sendPushNotification(
          toToken: fcmToken,
          title: 'Task Reminder: ${task.title}',
          body: body,
        );
      }
    } catch (e) {
      log("Error sending push notification: $e");
    }
  }

  // Method to sort tasks by priority
  Future<void> sortTasksByPriority() async {
    emit(state.copyWith(status: TaskListStatus.loading));

    try {
      List<TaskModel> sortedTasks = await taskRepository.sortTasksByPriority();
      emit(state.copyWith(tasks: sortedTasks, status: TaskListStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          error: CustomError(message: e.toString()),
          status: TaskListStatus.error,
        ),
      );
    }
  }

  // Fetch completed tasks with optional pagination (limit and lastDoc)
  Future<void> fetchCompletedTasks(
      {int limit = 3, DocumentSnapshot? lastDoc}) async {
    emit(state.copyWith(status: TaskListStatus.loading));

    try {
      // Fetch completed tasks from repository
      List<TaskModel> completedTasks = await taskRepository.fetchCompletedTasks(
        limit: limit,
        lastDoc: lastDoc, // Pass last document if available for pagination
      );

      // If state.completedTasks is null, initialize it as an empty list before adding new tasks
      final updatedCompletedTasks =
          List<TaskModel>.from(state.completedTasks ?? [])
            ..addAll(completedTasks);

      emit(state.copyWith(
        completedTasks: updatedCompletedTasks,
        status: TaskListStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: CustomError(message: e.toString()),
        status: TaskListStatus.error,
      ));
    }
  }
}
