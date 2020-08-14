import 'dart:developer';
import 'dart:typed_data';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/base/locator.dart';
import 'package:awrad/main.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/AdhanApi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

const adanLink = "adan";
const adanLinkIos = "ggg.aiff";

class NotificationService {
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

    mainBox.put(LAST_AZAN_SCHEDULE, DateTime.now().millisecondsSinceEpoch);
  }

  String _getAzanReminderState(String azanType) {
    return mainBox.get(azanType, defaultValue: "on");
  }

  reshechduleAwrad() async {
    int i = 10;

    for (var d = 0; d < daysOfWeek2.length; d++) {
      for (var t = 0; t < timesOfDay.length; t++) {
        await _scheduleAwrad(daysOfWeek2[d].dateWeek, t, i);
        i++;
      }
    }

    mainBox.put(LAST_AWRAD_SCHEDULE, DateTime.now().millisecondsSinceEpoch);
  }

  _scheduleAwrad(d, t, i) async {
    await flutterLocalNotificationsPlugin.cancel(i);
    final _rms = _getReminders(d, t);
    String title = "";
    String msg = "";
    String msgHtml = "";
    bool shouldScheduleForThisTime = true;
    switch (_rms.length) {
      case 0:
        shouldScheduleForThisTime = false;
        break;
      case 1:
        title = _rms.first.wrdName;
        if (_rms.first.isAwrad) {
          msgHtml = _rms.first.wrdText;
          msg = "اضغط لمزيد من التفاصيل";
        } else {
          msg = "اضغظ لقراءة ورد القرآن";
        }
        break;
      default:
        title = "لديك ${_rms.length} اوراد محفوظة";
        msg = "اضغط لقرآتهم الآن";
    }
    if (!shouldScheduleForThisTime) return;
    final adanTimes = await _api.todayAdan;
    final azanType = azanTimes[t].type;
    final azanDate = adanTimes.timings.getTimingDateTime(azanType);
    var timeNotification = azanDate.toNotificationTimeWithDelay();
    var bigTextStyleInformation;
    if (msgHtml.isNotEmpty)
      bigTextStyleInformation = BigTextStyleInformation(
        msgHtml,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true,
      );

    var androidPlatformChannelSpecifics;
    if (msgHtml.isNotEmpty)
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'wrdChannal',
        'قناة الأوراد',
        'هذه القناة مختصة لإظهار الاوراد المحفوظة',
        styleInformation: bigTextStyleInformation,
      );
    else
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'wrdChannal',
        'قناة الأوراد',
        'هذه القناة مختصة لإظهار الاوراد المحفوظة',
      );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      i,
      title,
      msg,
      _dateDayToNotificationDate(d),
      timeNotification,
      platformChannelSpecifics,
      payload: "awrad$t",
    );
  }

  List<ReminderModel> _getReminders(d, t) {
    return reminderBox.values
        .where((e) => e.days.contains(d) && e.times.contains(t))
        .toList();
  }

  Day _dateDayToNotificationDate(int dateTime) {
    return daysOfWeek2.firstWhere((e) => e.isTodayDate(dateTime)).notiDat;
  }

  // cancelSchedule(String uid) async {
  //   await _cancelPreviousSchedule(uid);
  // }

  // Future<void> _showWeeklyForWrd(
  //     ReminderModel rm, Day day, int time, lastID) async {
  //   //Remove the previously scheduled notification for this wrd + their keys in the box
  //   final adanTimes = await _api.todayAdan;
  //   final azanType = azanTimes[time].type;
  //   final azanDate = adanTimes.timings.getTimingDateTime(azanType);
  //   log("will save ${rm.id} of $day and time $azanType to id $lastSaveID");

  //   var timeNotification = azanDate.toNotificationTimeWithDelay();

  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'wrdChannal',
  //     'قناة الأوراد',
  //     'هذه القناة مختصة لإظهار الاوراد المحفوظة',
  //     // styleInformation:
  //   );
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
  //     lastID,
  //     rm.wrdName,
  //     rm.wrdText,
  //     day,
  //     timeNotification,
  //     platformChannelSpecifics,
  //     payload: rm.id,
  //   );
  // }

  Future<void> _showDailyForAzan(
      DateTime azanTime, int azanIndex, AzanTimeClass azanClass,
      {bool playSound = true, bool enableVibration = true}) async {
    var vibrationPattern = Int64List(6);
    vibrationPattern[0] = 100;
    vibrationPattern[1] = 300;
    vibrationPattern[2] = 100;
    vibrationPattern[3] = 300;
    vibrationPattern[4] = 100;
    vibrationPattern[5] = 400;
    var vibrationPatternEmoty = Int64List(1);
    vibrationPattern[0] = 100;

    var time = azanTime.toNotificationTime;
    var androidPlatformChannelSpecifics;

    final title =
        azanClass.isAdan ? 'صلاة ${azanClass.name}' : "وقت ${azanClass.name}";
    final message = azanClass.isAdan
        ? 'حان الآن موعد صلاة ${azanClass.name}'
        : "حان الآن موعد وقت ${azanClass.name}";

    var iOSPlatformChannelSpecifics;
    if (azanClass.isAdan) {
      iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: adanLinkIos,
        presentAlert: true,
        presentSound: true,
      );
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'AzanChannel',
        'قناة الأذان',
        'هذه القناة مختصة للتنبيه بأوقات الصلاة',
        playSound: playSound,
        vibrationPattern:
            enableVibration ? vibrationPattern : vibrationPatternEmoty,
        enableVibration: enableVibration,
        sound: RawResourceAndroidNotificationSound(adanLink),
      );
    } else {
      iOSPlatformChannelSpecifics = IOSNotificationDetails();
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'AzanChannel',
        'قناة الأذان',
        'هذه القناة مختصة للتنبيه بأوقات الصلاة',
        playSound: playSound,
        vibrationPattern:
            enableVibration ? vibrationPattern : vibrationPatternEmoty,
        enableVibration: enableVibration,
      );
    }
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      azanIndex,
      title,
      message,
      time,
      platformChannelSpecifics,
      payload: "azan",
    );
  }

  // _cancelPreviousSchedule(String uid) async {
  //   final keys = notificationBox.keys;
  //   for (var key in keys) {
  //     if (notificationBox.get(key) == uid) {
  //       log("$key , ${notificationBox.get(key)}");

  //       await notificationBox.delete(key);
  //       await flutterLocalNotificationsPlugin.cancel(key);
  //     }
  //   }
  // }

  int get lastSaveID {
    return mainBox.get(LAST_SAVED_ID, defaultValue: 10);
  }

  // _increaseLastID() async {
  //   final lastId = lastSaveID + 1;
  //   await mainBox.put(LAST_SAVED_ID, lastId);
  // }
}

extension dateToTime on DateTime {
  Time get toNotificationTime {
    return Time(this.hour, this.minute, this.second);
  }

  Time toNotificationTimeWithDelay() {
    final defaultMinuterInteval =
        mainBox.get(DEFAULT_INTERVAL_BETWEEN_AZAN_AND_WRD, defaultValue: 5);
    final newDate = this.add(Duration(minutes: defaultMinuterInteval));
    return Time(newDate.hour, newDate.minute, newDate.second);
  }
}
