import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/note_model.dart';
import '../models/task_item.dart';
import '../services/local_storage_service.dart';

class NoteController extends GetxController {
  final notes = <NoteModel>[].obs;
  final storage = LocalStorageService();

  @override
  void onInit() {
    notes.value = storage.getNotes();
    super.onInit();
  }

  void addNote(String title, List<TaskItem> tasks) {
    final now = DateTime.now();
    final note = NoteModel(
      id: Uuid().v4(),
      title: title,
      tasks: tasks,
      createdAt: now,
      updatedAt: now,
    );
    notes.add(note);
    save();
  }

  void deleteNote(String id) {
    notes.removeWhere((n) => n.id == id);
    save();
  }

  void deleteMultipleNotes(List<String> ids) {
    notes.removeWhere((note) => ids.contains(note.id));
    save();
  }

  void save() {
    storage.saveNotes(notes);
  }

  NoteModel getNoteById(String id) {
    return notes.firstWhere((n) => n.id == id);
  }

  void toggleTask(String noteId, int taskIndex) {
    final index = notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      final note = notes[index];
      note.tasks[taskIndex].isDone = !note.tasks[taskIndex].isDone;
      notes[index] = NoteModel(
        id: note.id,
        title: note.title,
        tasks: List.from(note.tasks),
        createdAt: note.createdAt,
        updatedAt: DateTime.now(), // Update timestamp
      );
      save();
    }
  }

  void addTaskToNote(String noteId, String taskText) {
    final index = notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      final note = notes[index];
      note.tasks.add(TaskItem(id: Uuid().v4(), text: taskText));
      notes[index] = NoteModel(
        id: note.id,
        title: note.title,
        tasks: List.from(note.tasks),
        createdAt: note.createdAt,
        updatedAt: DateTime.now(), // Update timestamp
      );
      save();
    }
  }


  // ✅ NEW: Remove a task by index
  void removeTask(String noteId, int taskIndex) {
    final index = notes.indexWhere((n) => n.id == noteId);
    if (index != -1 && taskIndex < notes[index].tasks.length) {
      final note = notes[index];
      note.tasks.removeAt(taskIndex);
      notes[index] = NoteModel(
        id: note.id,
        title: note.title,
        tasks: List.from(note.tasks),
        createdAt: note.createdAt,
        updatedAt: DateTime.now(), // Update timestamp
      );
      save();
    }
  }
  // ✅ NEW: Update the note title
  void updateNoteTitle(String noteId, String newTitle) {
    final index = notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      final note = notes[index];
      notes[index] = NoteModel(
        id: note.id,
        title: newTitle,
        tasks: List.from(note.tasks),
        createdAt: note.createdAt,
        updatedAt: DateTime.now(), // Update timestamp
      );
      save();
    }
  }
  // ✅ NEW: Update task text
  void updateTaskText(String noteId, int taskIndex, String newText) {
    final index = notes.indexWhere((n) => n.id == noteId);
    if (index != -1 && taskIndex < notes[index].tasks.length) {
      final note = notes[index];
      note.tasks[taskIndex] = TaskItem(
        id: note.tasks[taskIndex].id,
        text: newText,
        isDone: note.tasks[taskIndex].isDone,
      );
      notes[index] = NoteModel(
        id: note.id,
        title: note.title,
        tasks: List.from(note.tasks),
        createdAt: note.createdAt,
        updatedAt: DateTime.now(), // Update timestamp
      );
      save();
    }
  }
}
