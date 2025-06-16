import 'task_item.dart';

class NoteModel {
  final String id;
  final String title;
  final List<TaskItem> tasks;
  final DateTime createdAt;
  DateTime updatedAt; // Changed to non-final since we'll update it

  NoteModel({
    required this.id,
    required this.title,
    required this.tasks,
    required this.createdAt,
    DateTime? updatedAt, // Make it optional
  }) : updatedAt = updatedAt ?? createdAt; // Default to createdAt if not provided

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tasks': tasks.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(), // Add this line
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    final rawTasks = json['tasks'] as List;
    List<TaskItem> taskList = [];

    // Handle legacy format if task list is just strings
    if (rawTasks.isNotEmpty && rawTasks.first is String) {
      taskList = rawTasks.map((e) => TaskItem(text: e)).toList();
    } else {
      taskList = rawTasks.map((e) => TaskItem.fromJson(e)).toList();
    }

    return NoteModel(
      id: json['id'],
      title: json['title'],
      tasks: taskList,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.parse(json['createdAt']), // Fallback to createdAt if updatedAt doesn't exist
    );
  }
}