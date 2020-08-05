import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/base/locator.dart';
import 'package:awrad/services/AdhanApi.dart';

List<ADANTIMING> allAdanTypes;
initWorkManager() async {
  await Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  final nxtType = await nextAdanType();
  final nextAdan = await _getAdanByType(nxtType);
  _scheduleWorkManager(nextAdan);
}

Future<ADANTIMING> _getAdanByType(String type) async {
  final allAdan = await _allAdanTypesFromNow;
  return allAdan.firstWhere((e) => e.type == type);
}

_scheduleWorkManager(ADANTIMING nextAdan) async {
  final String type = nextAdan.type;
  final DateTime date = nextAdan.date;
  await Workmanager.cancelByTag(nextAdan.type);
  await Workmanager.registerOneOffTask(
    date.toString(),
    type,
    initialDelay: getDifferince(date),
    inputData: nextAdan.toMap(),
  ); //Android only (see below)
}

Duration getDifferince(DateTime future) {
  final dif = future.difference(DateTime.now());
  return dif;
}

Future<List<ADANTIMING>> get _allAdanTypesFromNow async {
  final azanSer = Get.find<AdhanApi>();
  var todaysAdan = await azanSer.todayAdan;
  var tommorowAdan = await azanSer.tommorowAdan;
  final now = DateTime.now();
  int i = 0;
  allAdanTypes = azanTimes.map((e) {
    DateTime date = todaysAdan.getDateByType(e.type);
    if (now.isAfter(date)) {
      date = tommorowAdan.getDateByType(e.type);
    }
    i++;
    return ADANTIMING(date: date, type: e.type, index: i);
  }).toList();
  allAdanTypes.sort((a, b) => a.date.compareTo(b.date));
  return allAdanTypes;
}

Future<String> nextAdanType({String nowType}) async {
  if (nowType != null) {
    final index = azanTimes.indexWhere((e) => e.type == nowType);
    if (index == azanTimes.length - 1) return azanTimes[0].type;
    return azanTimes[index + 1].type;
  } else {
    final allAdanTimes = await _allAdanTypesFromNow;
    return allAdanTimes[0].type;
  }
}

callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    final type = inputData['type'];
    final date = inputData['date'];
    final index = inputData['index'];
    await showNotification(type, date, index); // await _db
    final nxtType = await nextAdanType(nowType: type);
    final nextAdan = await _getAdanByType(nxtType);

    await _scheduleWorkManager(nextAdan);
    return Future.value(true);
  });
}

Future<void> showNotification(type, date, int index) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      index, type, date.toString(), platformChannelSpecifics,
      payload: 'item x');
}

class ADANTIMING {
  final String type;
  final DateTime date;
  final int index;
  ADANTIMING({
    this.type,
    this.date,
    this.index,
  });

  ADANTIMING copyWith({
    String type,
    DateTime date,
    int index,
  }) {
    return ADANTIMING(
      type: type ?? this.type,
      date: date ?? this.date,
      index: index ?? this.index,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'date': date?.millisecondsSinceEpoch,
      'index': index,
    };
  }

  static ADANTIMING fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ADANTIMING(
      type: map['type'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      index: map['index'],
    );
  }

  String toJson() => json.encode(toMap());

  static ADANTIMING fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'ADANTIMING(type: $type, date: $date, index: $index)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ADANTIMING &&
        o.type == type &&
        o.date == date &&
        o.index == index;
  }

  @override
  int get hashCode => type.hashCode ^ date.hashCode ^ index.hashCode;
}
