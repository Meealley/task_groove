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

  // Groove level configuration
  final List<Map<String, dynamic>> grooveLevels = [
    {"level": "Trailblazer", "minPoints": 0, "maxPoints": 399},
    {"level": "Seedling", "minPoints": 400, "maxPoints": 799},
    {"level": "Pathfinder", "minPoints": 800, "maxPoints": 1199},
    {"level": "Craftsman", "minPoints": 1200, "maxPoints": 1999},
    {"level": "Artisan", "minPoints": 2000, "maxPoints": 3199},
    {"level": "Virtuoso", "minPoints": 3200, "maxPoints": 7299},
    {"level": "Savant", "minPoints": 7300, "maxPoints": 20999},
    {"level": "Luminary", "minPoints": 21000, "maxPoints": 999999},
  ];

  // Get the user's current points
  Future<int> getUserPoints() async {
    DocumentSnapshot userDoc =
        await firestore.collection("users").doc(currentUserId).get();
    final data = userDoc.data()
        as Map<String, dynamic>?; // Cast to Map<String, dynamic> or null
    return data?["points"] ?? 0; // Safely access "points"
  }

  // Update the user's points and level
  Future<void> updatePoints(int pointsGained) async {
    try {
      DocumentReference userRef =
          firestore.collection("users").doc(currentUserId);

      int currentPoints = await getUserPoints();
      int newPoints = currentPoints + pointsGained;

      // Determine the new level
      String newLevel = grooveLevels.firstWhere((level) =>
          newPoints >= level['minPoints'] &&
          newPoints <= level['maxPoints'])['level'];

// Update firestore
      await userRef.update({
        "points": newPoints,
        "levels": newLevel,
      });

      log("User points updated to $newPoints, Level: $newLevel");
    } catch (e) {
      log("Error updating point : ${e.toString()}");
    }
  }

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

      await updatePoints(2);
      // Log the activity
      await recentActivityRepository.logActivity(
        taskID: task.id,
        action: "You created a task:",
        taskTitle: task.title,
        pointsGained: 2,
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
//   Future<void> updateTask(TaskModel task) async {
//     try {
//       DocumentReference taskRef = firestore
//           .collection("users")
//           .doc(currentUserId)
//           .collection("tasks")
//           .doc(task.id);
// //Check if the task is completed
//       bool wasCompleted = task.completed;

//       log("Updating task: ${task.toMap()}");
//       await taskRef.update(task.toMap());

//       if (!wasCompleted && task.completed) {
//         await updatePoints(5);
//         log("Task completes: Points awarded");
//       }

//       log("Task updated with priority: ${task.priority}");
//     } catch (e) {
//       log(e.toString());
//       throw CustomError(
//         code: "Error Updating task",
//         message: e.toString(),
//       );
//     }
//   }

  Future<void> updateTask(TaskModel task) async {
    try {
      DocumentReference taskRef = firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .doc(task.id);

      // Fetch the current task state from Firestore
      DocumentSnapshot taskSnapshot = await taskRef.get();
      if (!taskSnapshot.exists) {
        throw const CustomError(
          code: "TaskNotFound",
          message: "Task does not exist",
        );
      }

      Map<String, dynamic> currentData =
          taskSnapshot.data() as Map<String, dynamic>;
      bool wasCompleted = currentData['completed'] ?? false;

      log("Updating task: ${task.toMap()}");
      await taskRef.update(task.toMap());

      // Check for transition from not completed to completed
      if (!wasCompleted && task.completed) {
        await updatePoints(5);
        // Log the activity
        await recentActivityRepository.logActivity(
          taskID: task.id,
          action: "You completed a task:",
          taskTitle: task.title,
          pointsGained: 5,
        );
        log("Task completed: Points awarded");
      }

      log("Task updated with priority: ${task.priority}");
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Error Updating Task",
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

      // Retrieve all tasks for the user
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("tasks")
          .get();

      // Filter the tasks locally by comparing lowercased title, description, and status
      List<TaskModel> matchedTasks = snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).where((task) {
        String taskTitleLower = task.title.toLowerCase();
        String taskDescriptionLower = task.description.toLowerCase();

        // Ensure the task is active (not completed or deleted) and matches the search term
        bool isActive = !task.completed;
        bool matchesSearch = taskTitleLower.contains(lowerSearchTerm) ||
            taskDescriptionLower.contains(lowerSearchTerm);

        return isActive && matchesSearch;
      }).toList();

      log("Found ${matchedTasks.length} active tasks for search term: $searchTerm");

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
