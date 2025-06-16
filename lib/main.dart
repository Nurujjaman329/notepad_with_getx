import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:personal_notepad/view_models/theme_controller.dart';
import 'package:personal_notepad/views/home_screen.dart';
import 'package:get/get.dart';
import 'package:personal_notepad/widgets/app_colors.dart';
import 'package:timezone/data/latest_all.dart' as tz;



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <- Important for async calls in main

  await GetStorage.init();
  await AndroidAlarmManager.initialize(); // <- Required for alarm manager

  Get.put(ThemeController());

  tz.initializeTimeZones();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bajar List',
      themeMode:
      themeController.isDark ? ThemeMode.dark : ThemeMode.light,
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



