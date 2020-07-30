import 'dart:developer';

import 'package:awrad/base/locator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

initWorkManager() async {
  await Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  await Workmanager.registerOneOffTask(
    "azanTimer",
    "simpleTask",
    initialDelay: Duration(hours: 15),
  ); //Android only (see below)
}

callbackDispatcher() {
  // final _db = FirebaseDatabase.instance;
  // final _mainBox = Hive.box(MAINBOX);

  Workmanager.executeTask((task, inputData) async {
    log("Native called background task: $task ,$inputData");
    // final _db = FirebaseDatabase.instance;

    await showNotification(); // await _db
    //     .reference()
    //     .child("test")
    //     .push()
    //     .update({"date": "$task ${DateTime.now().toString()}"});

    await Workmanager.registerOneOffTask(
      DateTime.now().toString(),
      "simpleTask",
      initialDelay: Duration(hours: 1),
    );
    return Future.value(true);
  });
}

Future<void> showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      8, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}
