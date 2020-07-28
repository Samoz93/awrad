import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:workmanager/workmanager.dart';

initWorkManager() async {
  await Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  await Workmanager.registerPeriodicTask(
    "azanTimer",
    "simpleTask",
    frequency: Duration(minutes: 1),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    initialDelay: Duration(seconds: 30),
  ); //Android only (see below)
}

callbackDispatcher() {
  // final _db = FirebaseDatabase.instance;
  // final _mainBox = Hive.box(MAINBOX);

  Workmanager.executeTask((task, inputData) async {
    log("Native called background task: $task ,$inputData");
    final _db = FirebaseDatabase.instance;

    await _db
        .reference()
        .child("test")
        .push()
        .update({"date": "$task ${DateTime.now().toString()}"});
    // await Workmanager.registerOneOffTask(
    //   "azanTimer",
    //   "simpleTask",
    //   initialDelay: Duration(seconds: 30),
    // );
    return Future.value(true);
  });
}
