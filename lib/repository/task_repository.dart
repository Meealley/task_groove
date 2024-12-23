import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/repository/daily_streak_repository.dart';
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

      // Update Daily Streak
      DailyStreakRepository streakRepository =
          DailyStreakRepository(userId: currentUserId);
      await streakRepository.updateDailyStreak();

      // TODO: WORK ON THE POINTS AND AWARD ACCUMULATION
      // Log the activity
      await recentActivityRepository.logActivity(
        taskID: task.id,
        action: "You created a task:",
        taskTitle: task.title,
        pointsGained: 1,
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
      log("Updating task: ${task.toMap()}");
      await taskRef.update(task.toMap());
      log("Task updated with priority: ${task.priority}");
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
// Logging the user deleted activities
      await recentActivityRepository.logActivity(
        taskID: task.id,
        action: "You deleted a task:",
        taskTitle: task.title,
        pointsGained: 0,
      );
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
      // Convert the search term to lowercase
      String lowerSearchTerm = searchTerm.toLowerCase();

      // Retrieve a broader set of tasks based on title and description
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .get(); // Get all tasks

      // Filter the tasks locally by comparing lowercased title and description
      List<TaskModel> matchedTasks = snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).where((task) {
        String taskTitleLower = task.title.toLowerCase();
        String taskDescriptionLower = task.description.toLowerCase();

        // Check if either the title or description contains the search term
        return taskTitleLower.contains(lowerSearchTerm) ||
            taskDescriptionLower.contains(lowerSearchTerm);
      }).toList();

      log("Found ${matchedTasks.length} tasks for search term: $searchTerm");

      return matchedTasks;
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
          .orderBy("priority", descending: false)
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

  Future<List<TaskModel>> fetchCompletedTasks(
      {int limit = 3, DocumentSnapshot? lastDoc}) async {
    try {
      Query query = firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .where("completed", isEqualTo: true)
          .orderBy("createdAt", descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error fetching completed tasks",
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
          .orderBy('stopDateTime', descending: false)
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

  Future<List<TaskModel>> fetchOverdueTasks() async {
    final now = DateTime.now();
    // Fetch all tasks, then filter out the ones that are overdue and not completed
    final tasks = await fetchTasks();
    return tasks.where((task) {
      // Exclude completed tasks
      if (task.completed) return false;

      // If stopDateTime is set, use it to determine overdue status
      if (task.stopDateTime != null && task.stopDateTime!.isBefore(now)) {
        return true;
      }

      // If stopDateTime is not set but startDateTime is, check if the task is overdue by one day
      if (task.stopDateTime == null && task.startDateTime != null) {
        final oneDayAfterStart =
            task.startDateTime!.add(const Duration(days: 1));
        if (now.isAfter(oneDayAfterStart)) {
          return true;
        }
      }
      // Otherwise, the task is not overdue
      return false;
    }).toList();
  }
}
