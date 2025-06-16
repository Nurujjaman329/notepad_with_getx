import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/alarm_note_model.dart';
import '../view_models/alarm_controller.dart';
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
  final alarmController = Get.put(AlarmController());
  final selectedNotes = <String>{}.obs;
  final selectedBajarLists = <int>{}.obs;
  final selectedAlarms = <String>{}.obs;
  final isSelecting = false.obs;
  final selectedFilter = 'All'.obs;
  final filters = ['All', 'Notes', 'Bajar List', 'Alarms'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: Obx(() => Text(
          isSelecting.value
              ? '${selectedNotes.length + selectedBajarLists.length + selectedAlarms.length} selected'
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
                      selectedAlarms.clear();
                      isSelecting.value = false;
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed:
                    selectedNotes.isEmpty && selectedBajarLists.isEmpty && selectedAlarms.isEmpty
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
                  selectedNotes.addAll(noteController.notes.map((note) => note.id));
                  selectedBajarLists.addAll(List.generate(
                      bajarListController.bajarLists.length, (index) => index));
                  selectedAlarms.addAll(alarmController.alarms.map((alarm) => alarm.id));
                },
              );
            }
          })
        ],
      ),
      body: Obx(() {
        final notes = noteController.notes;
        final bajarLists = bajarListController.bajarLists;
        final alarms = alarmController.alarms;

        return CustomScrollView(slivers: [
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
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                          child:
                          Card(
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
                                      color: isSelected ? AppColors.primary : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    '${list.length} item(s) - Total: ৳${list.fold(0.0, (sum, e) => sum + e.amount).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: isSelected ? AppColors.primary : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Created: ${DateFormat('MMM d').format(list.first.createdAt)}', // Shows date of first item
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected ? AppColors.primary : Colors.grey,
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
                  if (selectedFilter.value == 'All' || selectedFilter.value == 'Alarms') ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Alarms',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: alarms.length,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (_, i) {
                        final alarm = alarms[i];
                        final isSelected = selectedAlarms.contains(alarm.id);
                        return GestureDetector(
                          onTap: () {
                            if (isSelecting.value) {
                              setState(() {
                                toggleAlarmSelection(alarm.id);
                              });
                            } else {
                              _showEditAlarmDialog(alarm);
                            }
                          },
                          onLongPress: () {
                            if (!isSelecting.value) {
                              isSelecting.value = true;
                            }
                            setState(() {
                              toggleAlarmSelection(alarm.id);
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        alarm.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? AppColors.primary : Colors.black,
                                        ),
                                      ),
                                      Switch(
                                        value: alarm.isActive,
                                        onChanged: (value) {
                                          alarmController.toggleAlarm(alarm.id, value);
                                        },
                                        activeColor: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  if (alarm.note != null && alarm.note!.isNotEmpty)
                                    Text(
                                      alarm.note!,
                                      style: TextStyle(
                                        color: isSelected ? AppColors.primary : Colors.grey,
                                      ),
                                    ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        DateFormat('MMM d, hh:mm a').format(alarm.dateTime),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected ? AppColors.primary : Colors.grey,
                                        ),
                                      ),
                                    ],
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
              SpeedDialChild(
                child: Icon(Icons.alarm, color: Colors.white),
                backgroundColor: AppColors.primary,
                label: 'Add Alarm',
                onTap: () => _showAddAlarmDialog(),
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
    if (selectedNotes.isEmpty && selectedBajarLists.isEmpty && selectedAlarms.isEmpty) {
      isSelecting.value = false;
    }
  }

  void toggleBajarListSelection(int index) {
    if (selectedBajarLists.contains(index)) {
      selectedBajarLists.remove(index);
    } else {
      selectedBajarLists.add(index);
    }
    if (selectedNotes.isEmpty && selectedBajarLists.isEmpty && selectedAlarms.isEmpty) {
      isSelecting.value = false;
    }
  }

  void toggleAlarmSelection(String alarmId) {
    if (selectedAlarms.contains(alarmId)) {
      selectedAlarms.remove(alarmId);
    } else {
      selectedAlarms.add(alarmId);
    }
    if (selectedNotes.isEmpty && selectedBajarLists.isEmpty && selectedAlarms.isEmpty) {
      isSelecting.value = false;
    }
  }

  void _showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Delete items'),
        content: Text(
            'Delete ${selectedNotes.length} notes, ${selectedBajarLists.length} bajar lists, and ${selectedAlarms.length} alarms?'),
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
                final indexes = selectedBajarLists.toList()
                  ..sort((a, b) => b.compareTo(a));
                for (var idx in indexes) {
                  bajarListController.deleteBajarList(idx);
                }
                selectedBajarLists.clear();
              }
              if (selectedAlarms.isNotEmpty) {
                for (var alarmId in selectedAlarms) {
                  alarmController.deleteAlarm(alarmId);
                }
                selectedAlarms.clear();
              }
              isSelecting.value = false;
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddAlarmDialog() {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(Duration(minutes: 5));

    Get.dialog(
      AlertDialog(
        title: Text('Add New Alarm'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Time'),
                subtitle: Text(DateFormat('MMM d, yyyy hh:mm a').format(selectedDate)),
                trailing: Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: Get.context!,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: Get.context!,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time != null) {
                      setState(() {
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final newAlarm = Alarm(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  note: noteController.text.isNotEmpty ? noteController.text : null,
                  dateTime: selectedDate,
                );
                alarmController.addAlarm(newAlarm);
                Get.back();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditAlarmDialog(Alarm alarm) {
    final titleController = TextEditingController(text: alarm.title);
    final noteController = TextEditingController(text: alarm.note ?? '');
    DateTime selectedDate = alarm.dateTime;

    Get.dialog(
      AlertDialog(
        title: Text('Edit Alarm'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Time'),
                subtitle: Text(DateFormat('MMM d, yyyy hh:mm a').format(selectedDate)),
                trailing: Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: Get.context!,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: Get.context!,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time != null) {
                      setState(() {
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final updatedAlarm = alarm.copyWith(
                  title: titleController.text,
                  note: noteController.text.isNotEmpty ? noteController.text : null,
                  dateTime: selectedDate,
                );
                alarmController.updateAlarm(alarm.id, updatedAlarm);
                Get.back();
              }
            },
            child: Text('Save'),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              alarmController.deleteAlarm(alarm.id);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}