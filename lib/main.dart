import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/MainPage.dart';

import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'base/locator.dart';

Box mainBox;
Box notificationBox;
Box<ReminderModel> reminderBox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  setupLocator();
  await setupNotification();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter<ReminderModel>(ReminderModelAdapter());

  mainBox = await Hive.openBox(
    MAINBOX,
    compactionStrategy: (entries, deletedEntries) {
      if (deletedEntries > 20) return true;
      return false;
    },
  );

  notificationBox = await Hive.openBox(
    NOTIFICATIONBOX,
    compactionStrategy: (entries, deletedEntries) {
      if (deletedEntries > 20) return true;
      return false;
    },
  );
  reminderBox = await Hive.openBox<ReminderModel>(
    REMINDER_BOX,
    compactionStrategy: (entries, deletedEntries) {
      if (deletedEntries > 20) return true;
      return false;
    },
  );
  _setupSchedule();
  runApp(MyApp());
}

const int minToUpdate = 5;
bool _shouldReschedule(String key) {
  final last = mainBox.get(key,
      defaultValue:
          DateTime.now().add(Duration(days: -4)).millisecondsSinceEpoch);
  final lastDate = DateTime.fromMillisecondsSinceEpoch(last);
  final x = DateTime.now().difference(lastDate).inHours;
  return x > minToUpdate;
}

_setupSchedule() {
  if (_shouldReschedule(LAST_AZAN_SCHEDULE))
    Get.find<NotificationService>().scheduleAzanTimes();

  if (_shouldReschedule(LAST_AWRAD_SCHEDULE))
    Get.find<NotificationService>().reshechduleAwrad();
}

class MyApp extends StatelessWidget {
  // final _exNavigatorKey = GlobalKey<ExtendedNavigatorState>();
  final _nab = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'أذكار الصالحين',
      navigatorKey: _nab,
      theme: ThemeData(
        primaryColor: AppColors.mainColorSelected,
        accentColor: AppColors.mainColor,
        fontFamily: "gg",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainPage(),
      ),
    );
  }
}
