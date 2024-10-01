// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

import 'package:equatable/equatable.dart';

class ActivityModel extends Equatable {
  final String id;
  final String taskID;
  final String taskTitle;
  final String action;
  final DateTime timestamp;
  final int pointsGained;

  const ActivityModel(
      {required this.id,
      required this.taskID,
      required this.taskTitle,
      required this.action,
      required this.timestamp,
      required this.pointsGained});

  @override
  List<Object> get props {
    return [
      id,
      taskID,
      taskTitle,
      action,
      timestamp,
      pointsGained,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'taskID': taskID,
      'taskTitle': taskTitle,
      'action': action,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'pointsGained': pointsGained,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as String,
      taskID: map['taskID'] as String,
      taskTitle: map['taskTitle'] as String,
      action: map['action'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      pointsGained: map['pointsGained'] as int,
    );
  }

  @override
  bool get stringify => true;

  ActivityModel copyWith({
    String? id,
    String? taskID,
    String? taskTitle,
    String? action,
    DateTime? timestamp,
    int? pointsGained,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      taskID: taskID ?? this.taskID,
      taskTitle: taskTitle ?? this.taskTitle,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      pointsGained: pointsGained ?? this.pointsGained,
    );
  }
}
