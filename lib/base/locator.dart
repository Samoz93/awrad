import 'dart:developer';

import 'package:awrad/Views/quran/QuranNewVM.dart';
import 'package:awrad/Views/services/SettingService.dart';
import 'package:awrad/models/ReceivedNotification.dart';
import 'package:awrad/services/AdhanApi.dart';
import 'package:awrad/services/BookService.dart';
import 'package:awrad/services/LocationService.dart';

import 'package:awrad/services/NotificationService.dart';
import 'package:awrad/services/QuranApi.dart';
import 'package:awrad/services/AwradService.dart';
import 'package:awrad/services/QuranService.dart';
import 'package:awrad/services/ReminderService.dart';
import 'package:awrad/services/SlidesService.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

final providers = [];
setupLocator() {
  Get.lazyPut<QuranApi>(() => QuranApi());
  Get.lazyPut<QuranService>(() => QuranService());
  Get.lazyPut<AwradService>(() => AwradService());
  Get.lazyPut<SlidesService>(() => SlidesService());

  Get.lazyPut<ReminderService>(() => ReminderService());
  Get.lazyPut<NotificationService>(() => NotificationService());
  Get.lazyPut<BookService>(() => BookService());
  Get.lazyPut<NotificationService>(() => NotificationService());
  Get.lazyPut<LocationSerivce>(() => LocationSerivce());
  Get.lazyPut<AdhanApi>(() => AdhanApi());
  Get.lazyPut<QuranNewVM>(() => QuranNewVM());
  Get.lazyPut<SettingService>(() => SettingService());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

BehaviorSubject<ReceivedNotification> iosData = BehaviorSubject();
BehaviorSubject<String> selectedData = BehaviorSubject();
setupNotification() async {
  try {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('mo');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        iosData.add(
          ReceivedNotification(
              id: id, body: body, title: title, payload: payload),
        );
        return;
      },
    );
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        selectedData.add(payload);
        return;
      },
    );
  } catch (e) {
    log(e);
  }
}
