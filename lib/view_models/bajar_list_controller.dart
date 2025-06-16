import 'package:get/get.dart';
import '../models/bajar_item_model.dart';
import '../services/local_storage_service.dart';

class BajarListController extends GetxController {
  final _storage = LocalStorageService();

  var bajarLists = <List<BajarItemModel>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBajarLists();
  }

  void loadBajarLists() {
    final lists = _storage.getBajarLists();
    bajarLists.assignAll(lists);
  }

  void addNewBajarList(List<BajarItemModel> newList) {
    bajarLists.add(newList);
    saveBajarListsLocally(); // ✅ make sure it's called here
  }

  void deleteBajarList(int index) {
    if (index >= 0 && index < bajarLists.length) {
      bajarLists.removeAt(index);
      saveBajarListsLocally();
    }
  }

  void addItemToList(int listIndex, BajarItemModel item) {
    bajarLists[listIndex].add(item);
    bajarLists.refresh();
    saveBajarListsLocally(); // ✅ also called after update
  }

  void saveBajarListsLocally() {
    _storage.saveBajarLists(bajarLists); // ✅ save using service
  }

  // Update item at given listIndex and itemIndex
  void updateItemInList(int listIndex, int itemIndex, BajarItemModel updatedItem) {
    bajarLists[listIndex][itemIndex] = updatedItem;
    bajarLists.refresh();
    saveBajarListsLocally();
  }

// Delete item at given listIndex and itemIndex
  void deleteItemInList(int listIndex, int itemIndex) {
    bajarLists[listIndex].removeAt(itemIndex);
    bajarLists.refresh();
    saveBajarListsLocally();
  }


  void toggleMarked(int listIndex, int itemIndex) {
    final list = bajarLists[listIndex];
    final item = list[itemIndex];
    item.isMarked = !item.isMarked; // now allowed after removing final
    bajarLists[listIndex] = [...list]; // Force reactivity
    saveBajarListsLocally();
  }


}
