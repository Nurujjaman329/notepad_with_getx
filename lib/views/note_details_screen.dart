import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/note_model.dart';
import '../models/task_item.dart';
import '../view_models/note_controller.dart';
import '../widgets/app_colors.dart';

class NoteDetailScreen extends StatelessWidget {
  final String noteId;
  final TextEditingController _taskController = TextEditingController();

  NoteDetailScreen({required this.noteId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Obx(() {
          final note = controller.getNoteById(noteId);
          return Text(
            note.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          );
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditTitleDialog(controller),
            tooltip: 'Edit title',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(controller),
            tooltip: 'More options',
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Progress bar
          Obx(() {
            final note = controller.getNoteById(noteId);
            final completedCount = note.tasks.where((t) => t.isDone).length;
            final totalCount = note.tasks.length;

            return totalCount > 0
                ? Column(
              children: [
                LinearProgressIndicator(
                  value: completedCount / totalCount,
                  backgroundColor: AppColors.border,
                  color: AppColors.secondary,
                  minHeight: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        'Tasks completed',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      Text(
                        '$completedCount/$totalCount',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : const SizedBox.shrink();
          }),

          // ✅ Task List
          Expanded(
            child: Obx(() {
              final note = controller.getNoteById(noteId);
              return note.tasks.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.checklist_rounded, size: 64, color: AppColors.textSecondary.withOpacity(0.3)),
                    const SizedBox(height: 16),
                     Text('No tasks yet', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                    Text(
                      'Add your first task below',
                      style: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: note.tasks.length,
                itemBuilder: (_, i) {
                  final task = note.tasks[i];
                  return _buildTaskItem(controller, note, task, i);
                },
              );
            }),
          ),

          // ✅ Task Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Add a new task...',
                      hintStyle:  TextStyle(color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:  BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:  BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: _taskController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => _taskController.clear(),
                      )
                          : null,
                    ),
                    style:  TextStyle(color: AppColors.textPrimary),
                    onChanged: (value) => controller.update(),
                    onSubmitted: (value) => _addTask(controller),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _addTask(controller),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(NoteController controller, NoteModel note, TaskItem task, int index) {
    return Dismissible(
      key: Key('${task.id}_${index}'), // Unique key for each item
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.danger.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: AppColors.danger),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await Get.dialog(
          AlertDialog(
            title: Text('Delete Task'),
            content: Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text('Delete', style: TextStyle(color: AppColors.danger)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => controller.removeTask(note.id, index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          leading: Checkbox(
            value: task.isDone,
            onChanged: (_) => controller.toggleTask(note.id, index),
            activeColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          title: Text(
            task.text,
            style: TextStyle(
              fontSize: 16,
              color: task.isDone ? AppColors.textSecondary : AppColors.textPrimary,
              decoration: task.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, size: 20),
                onPressed: () => _showEditTaskDialog(controller, note.id, index, task.text),
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              if (task.isDone)
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          minVerticalPadding: 0,
        ),
      ),
    );
  }

  void _addTask(NoteController controller) {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      controller.addTaskToNote(noteId, text);
      _taskController.clear();
    }
  }

  void _showEditTitleDialog(NoteController controller) {
    final note = controller.getNoteById(noteId);
    final titleController = TextEditingController(text: note.title);

    Get.dialog(
      AlertDialog(
        title: Text('Edit Note Title'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Note title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                controller.updateNoteTitle(noteId, titleController.text.trim());
                Get.back();
              }
            },
            child: Text('Save', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(NoteController controller, String noteId, int taskIndex, String currentText) {
    final taskController = TextEditingController(text: currentText);

    Get.dialog(
      AlertDialog(
        title: Text('Edit Task'),
        content: TextField(
          controller: taskController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Task text',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (taskController.text.trim().isNotEmpty) {
                controller.updateTaskText(noteId, taskIndex, taskController.text.trim());
                Get.back();
              }
            },
            child: Text('Save', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(NoteController controller) {
    final note = controller.getNoteById(noteId);
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.danger),
              title: Text('Delete Note', style: TextStyle(color: AppColors.danger)),
              onTap: () {
                Get.back();
                _showDeleteConfirmation(controller);
              },
            ),
            ListTile(
              leading: Icon(Icons.archive, color: AppColors.textSecondary),
              title: Text('Archive Note'),
              onTap: () {
                // Implement archive functionality
                Get.back();
                Get.snackbar('Note Archived', '${note.title} has been archived');
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: AppColors.textSecondary),
              title: Text('Duplicate Note'),
              onTap: () {
                // Implement duplicate functionality
                Get.back();
                Get.snackbar('Note Duplicated', '${note.title} has been copied');
              },
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(NoteController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteNote(noteId);
              Get.back(); // Go back to previous screen
            },
            child: Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}