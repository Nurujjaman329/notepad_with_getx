import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _isDark = false.obs;
  bool get isDark => _isDark.value;

  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Add theme color customization
  final _primaryColor = Color(0xFF4A90E2).obs;
  Color get primaryColor => _primaryColor.value;

  final _secondaryColor = Color(0xFF50E3C2).obs;
  Color get secondaryColor => _secondaryColor.value;

  @override
  void onInit() {
    _loadSavedTheme();
    super.onInit();
  }

  void _loadSavedTheme() {
    _isDark.value = _box.read(_key) ?? false;
    // You could also load saved custom colors here
  }

  void toggleTheme() {
    _isDark.value = !_isDark.value;
    Get.changeThemeMode(_isDark.value ? ThemeMode.dark : ThemeMode.light);
    _box.write(_key, _isDark.value);
  }

  void updatePrimaryColor(Color color) {
    _primaryColor.value = color;
    // Save to storage if you want persistent custom colors
  }

  void updateSecondaryColor(Color color) {
    _secondaryColor.value = color;
    // Save to storage if you want persistent custom colors
  }

  void resetToDefaultColors() {
    _primaryColor.value = const Color(0xFF4A90E2);
    _secondaryColor.value = const Color(0xFF50E3C2);
  }
}