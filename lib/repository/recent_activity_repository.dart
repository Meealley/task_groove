import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/models/acitvity_model.dart';
import 'package:task_groove/utils/custom_error.dart';

class RecentActivityRepository {
  String get currentUserId => auth.currentUser!.uid;

  // Log an acitvity ( create, update or delete )
  Future<void> logActivity({
    required String taskID,
    required String action,
    required String taskTitle,
    required int pointsGained,
  }) async {
    try {
      String activityId = uuid.v4();
      DateTime timestamp = DateTime.now();

      ActivityModel activity = ActivityModel(
        id: activityId,
        taskID: taskID,
        taskTitle: taskTitle,
        action: action,
        timestamp: timestamp,
        pointsGained: pointsGained,
      );

      // Save the activity to firestore
      DocumentReference activityRef = firestore
          .collection("users")
          .doc(currentUserId)
          .collection("recent_activity")
          .doc(activityId);

      await activityRef.set(activity.toMap());
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: 'Activity Loggging Error',
        message: e.toString(),
      );
    }
  }

  // Fetch recent activity
  Future<List<ActivityModel>> fetchRecentActivities() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("recent_activity")
          .orderBy("timestamp", descending: true)
          .limit(4)
          .get();

      return snapshot.docs.map((doc) {
        return ActivityModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: 'Activity Loggging Error',
        message: e.toString(),
      );
    }
  }

  // Fetch all recent activity
  Future<List<ActivityModel>> fetchAllActivities() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("recent_activity")
          .orderBy("timestamp", descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return ActivityModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: 'Activity Fetching Error',
        message: e.toString(),
      );
    }
  }

  // Listen for the realtime updates to recent activities
  Stream<List<ActivityModel>> listenToRecentActivities() {
    return firestore
        .collection("users")
        .doc(currentUserId)
        .collection("recent_activity")
        .orderBy("timestamp", descending: true)
        .limit(4)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ActivityModel.fromMap(doc.data());
      }).toList();
    });
  }
}
