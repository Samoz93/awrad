import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationSerivce {
  final _loc = Location();

  Future<LocationData> get location async {
    final hasPer = await askForPermissions();
    if (hasPer) {
      return await _loc.getLocation();
    } else {
      return null;
    }
  }

  Future<bool> askForPermissions() async {
    bool _hasPermission =
        (await _loc.hasPermission()) == PermissionStatus.granted;
    bool hasService = await _loc.serviceEnabled();

    if (hasService && _hasPermission) {
      //OK
    } else {
      await Get.dialog(
        AlertDialog(
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
        ),
      );
      if (!_hasPermission) {
        _hasPermission =
            (await _loc.requestPermission()) == PermissionStatus.granted;
      }
      if (!hasService) {
        hasService = await _loc.requestService();
      }
    }
    return _hasPermission && hasService;
  }
}
