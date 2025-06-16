import 'task_item.dart';

class NoteModel {
  final String id;
  final String title;
  final List<TaskItem> tasks;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.tasks,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tasks': tasks.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
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
    );
  }
}
