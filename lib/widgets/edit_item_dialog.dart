import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/bajar_item_model.dart';
import '../view_models/bajar_list_controller.dart';
import 'app_colors.dart';

class EditItemDialog extends StatelessWidget {
  final int listIndex;
  final int itemIndex;
  final BajarItemModel item;
  final BajarListController bajarListController;

  const EditItemDialog({
    Key? key,
    required this.listIndex,
    required this.itemIndex,
    required this.item,
    required this.bajarListController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: item.name);
    final weightController = TextEditingController(text: item.weight.toString());
    final amountController = TextEditingController(text: item.amount.toString());
    final RxString editSelectedUnit = item.unit.obs;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Item',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
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
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        value: editSelectedUnit.value,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                        items: ['gm', 'kg']
                            .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(
                            unit,
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) editSelectedUnit.value = val;
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
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {
                    final newName = nameController.text.trim();
                    final newWeight = double.tryParse(weightController.text.trim());
                    final newAmount = double.tryParse(amountController.text.trim());

                    if (newName.isEmpty || newWeight == null || newAmount == null) {
                      Get.snackbar(
                        'Error',
                        'Please fill all fields with valid values',
                        backgroundColor: AppColors.danger,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        borderRadius: 10,
                        margin: EdgeInsets.all(16),
                      );
                      return;
                    }

                    final updatedItem = BajarItemModel(
                      name: newName,
                      weight: newWeight,
                      unit: editSelectedUnit.value,
                      amount: newAmount,
                    );

                    bajarListController.updateItemInList(listIndex, itemIndex, updatedItem);
                    Get.back();
                  },
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}