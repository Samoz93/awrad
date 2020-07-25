import 'package:awrad/services/BookService.dart';
import 'package:awrad/services/LocalRepoService.dart';
import 'package:awrad/services/NotificationService.dart';
import 'package:awrad/services/QuranApi.dart';
import 'package:awrad/services/AwradService.dart';
import 'package:awrad/services/QuranService.dart';
import 'package:awrad/services/ReminderService.dart';
import 'package:awrad/services/SlidesService.dart';
import 'package:get/get.dart';

final providers = [];
setupLocator() {
  Get.lazyPut<QuranApi>(() => QuranApi());
  Get.lazyPut<QuranService>(() => QuranService());
  Get.lazyPut<AwradService>(() => AwradService());
  Get.lazyPut<SlidesService>(() => SlidesService());
  Get.lazyPut<LocalRepoSerivce>(() => LocalRepoSerivce());
  Get.lazyPut<ReminderService>(() => ReminderService());
  Get.lazyPut<NotificationService>(() => NotificationService());
  Get.lazyPut<BookService>(() => BookService());
}
