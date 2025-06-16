import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/bajar_item_model.dart';
import '../view_models/bajar_list_controller.dart';
import '../widgets/app_colors.dart';
import '../widgets/edit_item_dialog.dart';

class BajarListDetailScreen extends StatelessWidget {
  final int listIndex;

  BajarListDetailScreen({required this.listIndex});

  final BajarListController bajarListController = Get.find();

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final RxString selectedUnit = 'gm'.obs; // default unit

  @override
  Widget build(BuildContext context) {
    final list = bajarListController.bajarLists[listIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Bajar List #${listIndex + 1}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final currentList = bajarListController.bajarLists[listIndex];
              return currentList.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_basket,
                      size: 64,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No items added yet',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.only(top: 8),
                itemCount: currentList.length,
                itemBuilder: (_, index) {
                  final item = currentList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    elevation: 0,
                    color: AppColors.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.border, width: 1),
                    ),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          bajarListController.toggleMarked(listIndex, index);
                        },
                        child: Icon(
                          item.isMarked ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: item.isMarked ? Colors.green : AppColors.textSecondary,
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: TextStyle(
                          color: item.isMarked
                              ? AppColors.textSecondary.withOpacity(0.5)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          decoration: item.isMarked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(
                        '${item.weight} ${item.unit}',
                        style: TextStyle(
                          color: item.isMarked
                              ? AppColors.textSecondary.withOpacity(0.5)
                              : AppColors.textSecondary,
                        ),
                      ),
                       trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '৳${item.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                await _showEditItemDialog(context, listIndex, index, item);
                              } else if (value == 'delete') {
                                // Confirm delete dialog
                                final confirm = await Get.dialog<bool>(
                                  AlertDialog(
                                    title: Text('Delete Item'),
                                    content: Text('Are you sure you want to delete "${item.name}"?'),
                                    actions: [
                                      TextButton(onPressed: () => Get.back(result: false), child: Text('Cancel')),
                                      TextButton(onPressed: () => Get.back(result: true), child: Text('Delete')),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  bajarListController.deleteItemInList(listIndex, index);
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(value: 'delete', child: Text('Delete')),
                            ],
                            icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );

                },
              );
            }),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Add New Item',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: weightController,
                        keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Weight',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Obx(
                            () => Container(
                          height: 56,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedUnit.value,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down,
                                color: AppColors.textSecondary),
                            items: ['gm', 'kg']
                                .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(
                                unit,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) selectedUnit.value = val;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount (৳)',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final name = itemNameController.text.trim();
                      final weightText = weightController.text.trim();
                      final amountText = amountController.text.trim();
                      if (name.isEmpty ||
                          weightText.isEmpty ||
                          amountText.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please fill all fields',
                          backgroundColor: AppColors.danger,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          borderRadius: 10,
                          margin: EdgeInsets.all(16),
                        );
                        return;
                      }

                      final weight = double.tryParse(weightText);
                      final amount = double.tryParse(amountText);
                      if (weight == null || amount == null) {
                        Get.snackbar(
                          'Error',
                          'Invalid number format',
                          backgroundColor: AppColors.danger,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          borderRadius: 10,
                          margin: EdgeInsets.all(16),
                        );
                        return;
                      }

                      final item = BajarItemModel(
                        name: name,
                        unit: selectedUnit.value,
                        weight: weight,
                        amount: amount,
                      );

                      bajarListController.addItemToList(listIndex, item);

                      itemNameController.clear();
                      weightController.clear();
                      amountController.clear();

                      // Auto focus back to item name field
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Text(
                      'Add Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditItemDialog(
      BuildContext context,
      int listIndex,
      int itemIndex,
      BajarItemModel item,
      ) async {
    await Get.dialog(
      EditItemDialog(
        listIndex: listIndex,
        itemIndex: itemIndex,
        item: item,
        bajarListController: bajarListController,
      ),
      barrierDismissible: false,
    );
  }
}