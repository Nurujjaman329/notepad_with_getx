import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/bajar_item_model.dart';
import '../view_models/bajar_list_controller.dart';
import '../widgets/app_colors.dart';

class BajarListScreen extends StatefulWidget {
  @override
  _BajarListScreenState createState() => _BajarListScreenState();
}

class _BajarListScreenState extends State<BajarListScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _amountController = TextEditingController();
  String selectedUnit = 'kg';
  final List<BajarItemModel> items = [];

  final BajarListController controller = Get.find();

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.amount);

  void _addItem() {
    final name = _nameController.text.trim();
    final weight = double.tryParse(_weightController.text) ?? 0;
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (name.isNotEmpty && weight > 0 && amount > 0) {
      setState(() {
        items.add(BajarItemModel(
          name: name,
          unit: selectedUnit,
          weight: weight,
          amount: amount,
        ));
        _nameController.clear();
        _weightController.clear();
        _amountController.clear();
      });
    }
  }
  
  void _saveList() {
    if (items.isNotEmpty) {
      controller.addNewBajarList(List.from(items));
      Get.back();
    } else {
      Get.snackbar('Empty List', 'Add at least one item before saving',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bajar List', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedUnit,
                  items: ['kg', 'gm'].map((u) {
                    return DropdownMenuItem(value: u, child: Text(u));
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedUnit = v!;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Weight'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount (৳)'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: AppColors.primary),
                  onPressed: _addItem,
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                          '${item.weight} ${item.unit} - ৳${item.amount.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() => items.removeAt(i));
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ৳${totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _saveList,
                  child: Text("Save List"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
