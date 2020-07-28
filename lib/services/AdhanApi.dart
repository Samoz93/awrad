import 'dart:convert';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/AdanModel.dart';
import 'package:awrad/services/LocationService.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AdhanApi {
  final _locSer = Get.find<LocationSerivce>();
  final box = Hive.box(MAINBOX);
  final String _baseUrl = "http://api.aladhan.com/v1/";
  Future<AdanModel> get adanTimes async {
    final date = DateTime.now();
    final month = date.month;
    final year = date.year;
    final constDate = "$ADAN_DATA$month$year";
    String saveData = box.get(constDate);
    if (saveData == null) {
      final locData = await _locSer.location;

      final path =
          "calendar?latitude=${locData.latitude}&longitude=${locData.longitude}&method=2&month=$month&year=$year";

      final data = await getData(path, _baseUrl);
      final str = json.encode(data);
      await box.put(constDate, str);
      saveData = str;
    }

    final map = json.decode(saveData);
    return AdanModel.fromJson(map);
  }

  Future<AdanData> get todayAdan async {
    final day = DateTime.now().day;
    final sss = await adanTimes;
    final timing =
        sss.data.firstWhere((e) => int.parse(e.date.gregorian.day) == day);

    return timing;
  }
}
