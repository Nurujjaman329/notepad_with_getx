import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../models/alarm_note_model.dart';


class AlarmController extends GetxController {
  final alarms = <Alarm>[].obs;
  final _storageKey = 'alarms';
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadAlarms();
  }

  void loadAlarms() {
    final stored = _storage.read<List>(_storageKey);
    if (stored != null) {
      alarms.value = stored
          .map((e) => Alarm.fromMap(e as Map<String, dynamic>))
          .toList();
    }
  }

  void saveAlarms() {
    _storage.write(
      _storageKey,
      alarms.map((alarm) => alarm.toMap()).toList(),
    );
  }

  void addAlarm(Alarm alarm) {
    alarms.add(alarm);
    saveAlarms();
    if (alarm.isActive) {
      scheduleNotification(alarm);
    }
  }

  void updateAlarm(String id, Alarm updatedAlarm) {
    final index = alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      alarms[index] = updatedAlarm;
      saveAlarms();
      cancelNotification(id);
      if (updatedAlarm.isActive) {
        scheduleNotification(updatedAlarm);
      }
    }
  }

  void deleteAlarm(String id) {
    alarms.removeWhere((alarm) => alarm.id == id);
    saveAlarms();
    cancelNotification(id);
  }

  void toggleAlarm(String id, bool isActive) {
    final index = alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      final updated = alarms[index].copyWith(isActive: isActive);
      alarms[index] = updated;
      saveAlarms();
      if (isActive) {
        scheduleNotification(updated);
      } else {
        cancelNotification(id);
      }
    }
  }

  Future<void> scheduleNotification(Alarm alarm) async {
    if (!alarm.isActive) return;

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.id.hashCode,
        alarm.title,
        alarm.note ?? '⏰ Alarm triggered!',
        _scheduleTime(alarm.dateTime),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Alarm Notifications',
            channelDescription: 'Channel for alarm notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        payload: alarm.id,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
      await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.id.hashCode,
        alarm.title,
        alarm.note ?? '⏰ Alarm triggered!',
        _scheduleTime(alarm.dateTime),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Alarm Notifications',
            channelDescription: 'Channel for alarm notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        payload: alarm.id,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }


  Future<void> cancelNotification(String id) async {
    await flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }

  tz.TZDateTime _scheduleTime(DateTime dateTime) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime.from(dateTime, tz.local);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}