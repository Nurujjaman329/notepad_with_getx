import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:personal_notepad/view_models/theme_controller.dart';
import 'package:personal_notepad/views/home_screen.dart';
import 'package:get/get.dart';
import 'package:personal_notepad/widgets/app_colors.dart';

void main() async {
  await GetStorage.init();
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bajar List',
      themeMode: themeController.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.cardBackground,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.cardBackground,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      home: HomeScreen(),
    ));
  }
}



