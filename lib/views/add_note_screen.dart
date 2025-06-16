import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task_item.dart';
import '../view_models/note_controller.dart';
import '../widgets/app_colors.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _taskController = TextEditingController();
  final List<TaskItem> tasks = [];

  void _addTask(String text) {
    final trimmed = text.trim();
    if (trimmed.isNotEmpty) {
      setState(() {
        tasks.add(TaskItem(text: trimmed));
        _taskController.clear();
      });
    }
  }

  void _toggleTaskDone(String taskId) {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      setState(() {
        tasks[index].isDone = !tasks[index].isDone;
      });
    }
  }

  void _removeTask(String taskId) {
    setState(() {
      tasks.removeWhere((t) => t.id == taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: Text("New Note", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: "Add a task and press enter",
                    ),
                    onSubmitted: _addTask,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addTask(_taskController.text),
                )
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (_, i) {
                  final task = tasks[i];
                  return ListTile(
                    key: ValueKey(task.id),
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (_) => _toggleTaskDone(task.id),
                    ),
                    title: Text(
                      task.text,
                      style: TextStyle(
                        decoration:
                        task.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeTask(task.id),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: () {
                if (_titleController.text.trim().isNotEmpty &&
                    tasks.isNotEmpty) {
                  Get.find<NoteController>().addNote(
                    _titleController.text.trim(),
                    tasks,
                  );
                  Get.back();
                } else {
                  Get.snackbar("Missing Info", "Please add title and tasks");
                }
              },
              child: Text("Save Note"),
            )
          ],
        ),
      ),
    );
  }
}