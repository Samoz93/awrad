import 'dart:developer';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/base/locator.dart';
import 'package:awrad/main.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/AdhanApi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  // final _mainBox = Hive.box(MAINBOX);
  // final _reminderBox = Hive.box(REMINDER_BOX);

  final _api = Get.find<AdhanApi>();
  testRemoveAll() async {
    await notificationBox.clear();
    await flutterLocalNotificationsPlugin.cancelAll();
    await mainBox.delete(LAST_SAVED_ID);
  }

  scheduleAzanTimes() async {
    final adanTimes = await _api.todayAdan;

    for (var i = 0; i < azanTimes.length; i++) {
      final aznCls = azanTimes[i];
      final azanDate = adanTimes.timings.getTimingDateTime(aznCls.type);
      final notificationType = _getAzanReminderState(aznCls.type);
      bool hasSound = true;
      bool enableVibration = true;
      if (notificationType == "off") {
        hasSound = false;
        enableVibration = false;
        await flutterLocalNotificationsPlugin.cancel(i);
        log("canceld azan ${aznCls.type}");
      } else {
        if (notificationType == "silent") {
          hasSound = false;
        }
        await _showDailyForAzan(azanDate, i, aznCls,
            enableVibration: enableVibration, playSound: hasSound);
        log("scheduled azan ${aznCls.type}");
      }
    }
  }

  String _getAzanReminderState(String azanType) {
    return mainBox.get(azanType, defaultValue: "on");
  }

  reshedule() {}
  scheduleWrdNotification(ReminderModel rm) async {
    await _cancelPreviousSchedule(rm.id);

    for (var d = 0; d < rm.days.length; d++) {
      for (var t = 0; t < rm.times.length; t++) {
        await _showWeeklyForWrd(rm, rm.days[d], rm.times[t], lastSaveID);
        await notificationBox.put(lastSaveID, rm.id);
        await _increaseLastID();
        log("saved ${rm.id} next id will be $lastSaveID");
      }
    }
  }

  cancelSchedule(String uid) async {
    await _cancelPreviousSchedule(uid);
  }

  Future<void> _showWeeklyForWrd(
      ReminderModel rm, int day, int time, lastID) async {
    //Remove the previously scheduled notification for this wrd + their keys in the box
    final adanTimes = await _api.todayAdan;
    final dayNotification = Day(day + 1);
    final azanType = azanTimes[time].type;
    final azanDate = adanTimes.timings.getTimingDateTime(azanType);
    log("will save ${rm.id} of $day and time $azanType to id $lastSaveID");

    var timeNotification = azanDate.toNotificationTimeWithDelay();

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'wrdChannal',
        'قناة الأوراد',
        'هذه القناة مختصة لإظهار الاوراد المحفوظة');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      lastID,
      rm.wrdName,
      rm.wrdText,
      dayNotification,
      timeNotification,
      platformChannelSpecifics,
      payload: rm.id,
    );
  }

  Future<void> _showDailyForAzan(
      DateTime azanTime, int azanIndex, AzanTimeClass azanClass,
      {bool playSound = true, bool enableVibration = true}) async {
    var time = azanTime.toNotificationTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'AzanChannel',
      'قناة الأذان',
      'هذه القناة مختصة للتنبيه بأوقات الصلاة',
      playSound: playSound,
      enableVibration: enableVibration,
      // sound: NotificationSound
      //TODO add azan sound
    );
    final title =
        azanClass.isAdan ? 'صلاة ${azanClass.name}' : "وقت ${azanClass.name}";
    final message = azanClass.isAdan
        ? 'حان الآن موعد صلاة ${azanClass.name}'
        : "حان الآن موعد وقت ${azanClass.name}";

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      azanIndex,
      title,
      message,
      time,
      platformChannelSpecifics,
      //TODO add named route
      payload: "azan",
    );
  }

  _cancelPreviousSchedule(String uid) async {
    final keys = notificationBox.keys;
    for (var key in keys) {
      if (notificationBox.get(key) == uid) {
        log("$key , ${notificationBox.get(key)}");

        await notificationBox.delete(key);
        await flutterLocalNotificationsPlugin.cancel(key);
      }
    }
  }

  int get lastSaveID {
    return mainBox.get(LAST_SAVED_ID, defaultValue: 10);
  }

  _increaseLastID() async {
    final lastId = lastSaveID + 1;
    await mainBox.put(LAST_SAVED_ID, lastId);
  }
}

extension dateToTime on DateTime {
  Time get toNotificationTime {
    return Time(this.hour, this.minute, this.second);
  }

  Time toNotificationTimeWithDelay() {
    final defaultMinuterInteval =
        mainBox.get(DEFAULT_INTERVAL_BETWEEN_AZAN_AND_WRD, defaultValue: 5);

    return Time(this.hour, this.minute + defaultMinuterInteval, this.second);
  }
}
