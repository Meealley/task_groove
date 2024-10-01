import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/repository/recent_activity_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

class TaskRepository {
  // Get user's current uid

  String get currentUserId => auth.currentUser!.uid;
  RecentActivityRepository recentActivityRepository =
      RecentActivityRepository();

  // Add a new task to the current user task
  Future<void> addTask(TaskModel task) async {
    try {
      //Generate a unique task id using uuid
      String taskId = uuid.v4();
      task = task.copyWith(
        id: taskId,
        createdAt: DateTime.now(),
      );

      DocumentReference taskRef = firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .doc(task.id);
      await taskRef.set(task.toMap());

      // Log the activity

      await recentActivityRepository.logActivity(
        taskID: task.id,
        action: "You created a task:",
        taskTitle: task.title,
        pointsGained: 10,
      );
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error adding task",
        message: e.toString(),
      );
    }
  }

  // Update an existing task in the current user data collection
  Future<void> updateTask(TaskModel task) async {
    try {
      DocumentReference taskRef = firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .doc(task.id);

      await taskRef.update(task.toMap());
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error Updating task",
        message: e.toString(),
      );
    }
  }

  // Delete a task from user data collection
  Future<void> deleteTask(TaskModel task) async {
    try {
      DocumentReference taskRef = firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .doc(task.id);

      await taskRef.delete();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error Deleting task",
        message: e.toString(),
      );
    }
  }

  // Fetch all tasks from user data collection
  Future<List<TaskModel>> fetchTasks() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .orderBy("createdAt")
          .get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error Fetching tasks",
        message: e.toString(),
      );
    }
  }

  // Search tasks by title of description
  Future<List<TaskModel>> searchTasks(String searchTerm) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .where('title', isGreaterThanOrEqualTo: searchTerm)
          .where("title", isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .where('description', isGreaterThanOrEqualTo: searchTerm)
          .where("description", isLessThan: '$searchTerm\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error Searching for tasks",
        message: e.toString(),
      );
    }
  }

  // Sort by tasks by priority (1: High, 2: Medium, 3:Low)
  Future<List<TaskModel>> sortTasksByPriority() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .orderBy("priority", descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error Sorting by Priority",
        message: e.toString(),
      );
    }
  }

  // Sort tasks by completion status (completed first, then pending)
  Future<List<TaskModel>> sortTasksByCompletionStatus() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .orderBy("completed", descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error Searching for tasks",
        message: e.toString(),
      );
    }
  }

  Future<List<TaskModel>> sortTasksByDueDate() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .orderBy('stopDateTime')
          .get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error Searching for tasks",
        message: e.toString(),
      );
    }
  }
}
