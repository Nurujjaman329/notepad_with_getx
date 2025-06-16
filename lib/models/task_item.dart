import 'package:uuid/uuid.dart';

class TaskItem {
  final String id;
  String text;
  bool isDone;

  TaskItem({
    String? id,
    required this.text,
    this.isDone = false,
  }) : id = id ?? Uuid().v4(); // auto-generate id if not provided

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
    id: json['id'],
    text: json['text'],
    isDone: json['isDone'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isDone': isDone,
  };
}
