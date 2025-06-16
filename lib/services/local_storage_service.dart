import 'package:get_storage/get_storage.dart';
import '../models/note_model.dart';
import '../models/bajar_item_model.dart';

class LocalStorageService {
  final _storage = GetStorage();

  final _notesKey = 'notes';
  final _bajarListKey = 'bajar_lists';

  // Notes
  List<NoteModel> getNotes() {
    final data = _storage.read(_notesKey);
    if (data != null) {
      return List<Map<String, dynamic>>.from(data)
          .map((e) => NoteModel.fromJson(e))
          .toList();
    }
    return [];
  }

  void saveNotes(List<NoteModel> notes) {
    final raw = notes.map((e) => e.toJson()).toList();
    _storage.write(_notesKey, raw);
  }

  // Bajar Lists
  List<List<BajarItemModel>> getBajarLists() {
    final data = _storage.read(_bajarListKey);
    if (data != null) {
      return List<List<dynamic>>.from(data).map((list) =>
          list.map((e) => BajarItemModel.fromJson(Map<String, dynamic>.from(e))).toList()
      ).toList();
    }
    return [];
  }

  void saveBajarLists(List<List<BajarItemModel>> bajarLists) {
    final raw = bajarLists
        .map((list) => list.map((item) => item.toJson()).toList())
        .toList();
    _storage.write(_bajarListKey, raw);
  }

}
