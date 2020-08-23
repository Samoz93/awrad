import 'dart:convert';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/main.dart';
import 'package:awrad/models/AdanModel.dart';
import 'package:awrad/services/LocationService.dart';
import 'package:get/get.dart';

class AdhanApi {
  final _locSer = Get.find<LocationSerivce>();
  final String _baseUrl = "http://api.aladhan.com/v1/";

  String get azanDateConst {
    return "$ADAN_DATA$azanMonth$azanYear";
  }

  int get azanMonth {
    final date = DateTime.now();
    return date.month;
  }

  int get azanYear {
    final date = DateTime.now();
    return date.year;
  }

  Future<AdanModel> get adanTimes async {
    // await mainBox.delete(azanDateConst);
    String saveData = mainBox.get(azanDateConst);
    if (saveData == null) {
      final locData = await _locSer.location;

      final path =
          "calendar?latitude=${locData.latitude}&longitude=${locData.longitude}&method=2&month=$azanMonth&year=$azanYear&method=$azanMethod";

      final data = await getData(path, _baseUrl);
      final str = json.encode(data);
      await mainBox.put(azanDateConst, str);
      saveData = str;
    }

    final map = json.decode(saveData);
    return AdanModel.fromJson(map);
  }

  refreshDates(int method) async {
    await mainBox.put(AZAN_MEHODE, method);
    final locData = await _locSer.location;

    final path =
        "calendar?latitude=${locData.latitude}&longitude=${locData.longitude}&method=2&month=$azanMonth&year=$azanYear&method=$azanMethod";

    final data = await getData(path, _baseUrl);
    final str = json.encode(data);
    await mainBox.put(azanDateConst, str);
  }

  int get azanMethod {
    return mainBox.get(AZAN_MEHODE, defaultValue: 4);
  }

  Future<AdanData> get todayAdan async {
    final day = DateTime.now().day;
    final sss = await adanTimes;
    final timing =
        sss.data.firstWhere((e) => int.parse(e.date.gregorian.day) == day);

    return timing;
  }

  Future<AdanData> get tommorowAdan async {
    final day = DateTime.now().add(Duration(days: 1)).day;
    final sss = await adanTimes;
    final timing =
        sss.data.firstWhere((e) => int.parse(e.date.gregorian.day) == day);

    return timing;
  }
}
