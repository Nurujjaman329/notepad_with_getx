import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/bajar_list_controller.dart';
import '../view_models/note_controller.dart';
import '../widgets/app_colors.dart';
import 'add_note_screen.dart';
import 'bajar_list_details_screen.dart';
import 'bajar_list_screen.dart';
import 'note_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final noteController = Get.put(NoteController());
  final bajarListController = Get.put(BajarListController());
  final selectedNotes = <String>{}.obs;
  final selectedBajarLists = <int>{}.obs;
  final isSelecting = false.obs;
  final selectedFilter = 'All'.obs;
  final filters = ['All', 'Notes', 'Bajar List'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: Obx(() => Text(
              isSelecting.value
                  ? '${selectedNotes.length + selectedBajarLists.length} selected'
                  : 'Daily Task & Bajar Lists',
              style: TextStyle(color: Colors.white),
            )),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Obx(() {
            if (isSelecting.value) {
              return Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      selectedNotes.clear();
                      selectedBajarLists.clear();
                      isSelecting.value = false;
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed:
                        selectedNotes.isEmpty && selectedBajarLists.isEmpty
                            ? null
                            : () {
                                _showDeleteConfirmationDialog();
                              },
                  ),
                ],
              );
            } else {
              return IconButton(
                icon: Icon(Icons.select_all),
                onPressed: () {
                  isSelecting.value = true;
                  selectedNotes
                      .addAll(noteController.notes.map((note) => note.id));
                  selectedBajarLists.addAll(List.generate(
                      bajarListController.bajarLists.length, (index) => index));
                },
              );
            }
          })
        ],
      ),
      body: Obx(() {
        final notes = noteController.notes;
        final bajarLists = bajarListController.bajarLists;

        return CustomScrollView(slivers: [
          // Sticky filter bar
          SliverAppBar(
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 2,
            toolbarHeight: 60,
            collapsedHeight: 60,
            expandedHeight: 60,
            flexibleSpace: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = selectedFilter.value == filter;

                    return GestureDetector(
                      onTap: () => selectedFilter.value = filter,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        margin: EdgeInsets.only(left: index == 0 ? 0 : 0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Content
          SliverList(
              delegate: SliverChildListDelegate(
            [
              if (selectedFilter.value == 'All' ||
                  selectedFilter.value == 'Notes') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Notes',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (_, i) {
                    final note = notes[i];
                    final isSelected = selectedNotes.contains(note.id);
                    return GestureDetector(
                      onTap: () {
                        if (isSelecting.value) {
                          setState(() {
                            toggleNoteSelection(note.id);
                          });
                        } else {
                          Get.to(() => NoteDetailScreen(noteId: note.id));
                        }
                      },
                      onLongPress: () {
                        if (!isSelecting.value) {
                          isSelecting.value = true;
                        }
                        setState(() {
                          toggleNoteSelection(note.id);
                        });
                      },
                      child: Card(
                        color: AppColors.cardBackground,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.border, width: 1),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.white,
                              ),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${note.tasks.length} item(s)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 10, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        DateFormat('MMM d')
                                            .format(note.createdAt),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (isSelecting.value)
                              Positioned.fill(
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.3)
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            if (isSelecting.value)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check,
                                          size: 16, color: Colors.white)
                                      : null,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
              if (selectedFilter.value == 'All' ||
                  selectedFilter.value == 'Bajar List') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Bajar List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bajarLists.length,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (_, i) {
                    final list = bajarLists[i];
                    final isSelected = selectedBajarLists.contains(i);
                    return GestureDetector(
                      onTap: () {
                        if (isSelecting.value) {
                          setState(() {
                            toggleBajarListSelection(i);
                          });
                        } else {
                          Get.to(() => BajarListDetailScreen(listIndex: i));
                        }
                      },
                      onLongPress: () {
                        if (!isSelecting.value) {
                          isSelecting.value = true;
                        }
                        setState(() {
                          toggleBajarListSelection(i);
                        });
                      },
                      child: Card(
                        color: AppColors.cardBackground,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.border, width: 1),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'List #${i + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '${list.length} item(s) - Total: ৳${list.fold(0.0, (sum, e) => sum + e.amount).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ))
        ]);
      }),
      floatingActionButton: Obx(() => AnimatedSlide(
            duration: Duration(milliseconds: 200),
            offset: isSelecting.value ? Offset(0, 2) : Offset.zero,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: isSelecting.value ? 0 : 1,
              child: SpeedDial(
                icon: Icons.add,
                iconTheme: IconThemeData(color: AppColors.background),
                activeIcon: Icons.close,
                backgroundColor: AppColors.primary,
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.edit_note, color: Colors.white),
                    backgroundColor: AppColors.primary,
                    label: 'Add Note',
                    onTap: () => Get.to(() => AddNoteScreen()),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.shopping_cart, color: Colors.white),
                    backgroundColor: AppColors.primary,
                    label: 'Bajar List',
                    onTap: () => Get.to(() => BajarListScreen()),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void toggleNoteSelection(String noteId) {
    if (selectedNotes.contains(noteId)) {
      selectedNotes.remove(noteId);
    } else {
      selectedNotes.add(noteId);
    }
    if (selectedNotes.isEmpty && selectedBajarLists.isEmpty)
      isSelecting.value = false;
  }

  void toggleBajarListSelection(int index) {
    if (selectedBajarLists.contains(index)) {
      selectedBajarLists.remove(index);
    } else {
      selectedBajarLists.add(index);
    }
    if (selectedNotes.isEmpty && selectedBajarLists.isEmpty)
      isSelecting.value = false;
  }

  void _showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Delete items'),
        content: Text(
            'Delete ${selectedNotes.length} notes and ${selectedBajarLists.length} bajar lists?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (selectedNotes.isNotEmpty) {
                noteController.deleteMultipleNotes(selectedNotes.toList());
                selectedNotes.clear();
              }
              if (selectedBajarLists.isNotEmpty) {
                // Delete bajar lists by index in descending order to avoid shifting
                final indexes = selectedBajarLists.toList()
                  ..sort((a, b) => b.compareTo(a));
                for (var idx in indexes) {
                  bajarListController.deleteBajarList(idx);
                }
                selectedBajarLists.clear();
              }
              isSelecting.value = false;
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
