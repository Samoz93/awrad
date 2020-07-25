import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:awrad/services/AdanService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';

class AdanVm extends BaseViewModel {
  final _loc = Location.instance;

  final _prayerSer = AdanService();
  bool _hasPermission = false;
  bool get hasPermission => _hasPermission;

  askForPermissions() async {
    setBusy(true);

    final per = await _loc.hasPermission();
    _hasPermission = per == PermissionStatus.granted;
    final hasService = await _loc.serviceEnabled();
    if (hasService && _hasPermission) {
    } else {
      await Get.dialog(AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text("موافق"),
            onPressed: () {
              Get.back();
            },
          )
        ],
        title: Text("أذونات مطلوبة"),
        content: Text(
            "لحساب اوقات الصلاة نحتاج للوصول إلى معلومات موقعك , يرجى الموافقة على الاذونات التالية"),
      ));
      if (!_hasPermission) {
        final per2 = await _loc.requestPermission();
        _hasPermission = per2 == PermissionStatus.granted;
      }
      if (!hasService) {
        final ser2 = await _loc.requestService();
        _hasPermission = ser2;
      }
    }
    setBusy(false);
  }

  Future<PrayerTimes> get adanTimes async {
    final loc = await _loc.getLocation();
    return _prayerSer.getTodayPryers(loc);
  }
}
