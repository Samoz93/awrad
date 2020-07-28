import 'package:awrad/base/locator.dart';
import 'package:awrad/models/AdanModel.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/AdhanApi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  // final _mainBox = Hive.box(MAINBOX);
  // final _reminderBox = Hive.box(REMINDER_BOX);

  final _api = Get.find<AdhanApi>();
  AdanData _todayAdan;
  Future<AdanData> get todayAdan async {
    if (_todayAdan == null) {
      _todayAdan = await _api.todayAdan;
    }
    return _todayAdan;
  }

  reshedule() {}
  scheduleNotification(ReminderModel rm) {}

  cancelSchedule(int id) {}

  Future<void> _showWeeklyAtDayAndTime(
      String title, String body, int weekDay, int) async {
    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0, 'show weekly title', '', Day.Monday, time, platformChannelSpecifics);
  }
}
