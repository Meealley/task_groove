import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final DateTime? reminder;
  final DateTime? startDateTime;
  final DateTime? stopDateTime;
  final int priority;
  final DateTime createdAt; // New field for task creation time

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    this.reminder,
    this.startDateTime,
    this.stopDateTime,
    required this.priority,
    required this.createdAt,
  });

  // CopyWith method for creating a copy of the TaskModel with updated fields
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? reminder,
    DateTime? startDateTime,
    DateTime? stopDateTime,
    int? priority,
    DateTime? createdAt, // Add priority to copyWith
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      reminder: reminder ?? this.reminder,
      startDateTime: startDateTime ?? this.startDateTime,
      stopDateTime: stopDateTime ?? this.stopDateTime,
      priority: priority ?? this.priority, // Copy priority if updated
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert TaskModel to map for storing in Firebase or database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'reminder': reminder?.millisecondsSinceEpoch,
      'startDateTime': startDateTime?.millisecondsSinceEpoch,
      'stopDateTime': stopDateTime?.millisecondsSinceEpoch,
      'priority': priority, // Add priority to map
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Factory method to create TaskModel from a map (useful for reading from DB)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      completed: map['completed'] ?? false,
      reminder: map['reminder'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reminder'])
          : null,
      startDateTime: map['startDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDateTime'])
          : null,
      stopDateTime: map['stopDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['stopDateTime'])
          : null,
      priority: map['priority'] ?? 3, // Default priority to low if null
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      completed,
      reminder,
      startDateTime,
      stopDateTime,
      priority,
      createdAt,
    ];
  }

  @override
  bool get stringify => true;
}
