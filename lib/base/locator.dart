import 'package:awrad/base/notification.dart';
import 'package:awrad/services/Api.dart';
import 'package:awrad/services/AwradService.dart';
import 'package:awrad/services/QuranService.dart';
import 'package:awrad/services/SlidesService.dart';
import 'package:get/get.dart';

final providers = [];
setupLocator() {
  Get.lazyPut<NotificationCenter>(() => NotificationCenter());
  Get.lazyPut<Api>(() => Api());
  Get.lazyPut<QuranService>(() => QuranService());
  Get.lazyPut<AwradService>(() => AwradService());
  Get.lazyPut<SlidesService>(() => SlidesService());
}
