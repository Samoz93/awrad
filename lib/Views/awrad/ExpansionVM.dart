import 'dart:developer';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';

class ExpansionVM extends BaseViewModel {
  final id;
  Box<ReminderModel> box;
  ExpansionVM({@required this.id}) {
    _initData();
  }
  _initData() {
    try {
      box = Hive.box<ReminderModel>(REMINDER_BOX);
      rm = box.values.firstWhere((element) => element.id == id);
      if (rm != null) {
        _days = rm.days;
        _times = rm.times;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  ReminderModel rm;

  bool get hasReminder => rm != null;

  bool _showAlaramOption = false;
  bool get showAlaramOption => _showAlaramOption;
  toggelAlarmOption() {
    _showAlaramOption = !_showAlaramOption;
    notifyListeners();
  }

  List<int> _days = [];
  List<int> _times = [];

  List<bool> get selectionBool {
    return daysOfWeekInt.map((e) => _days.contains(e)).toList();
  }

  List<bool> get selectionBoolTimes {
    return timesOfDayInt.map((e) => _times.contains(e)).toList();
  }

  getDayName(int day) {
    return daysOfWeek[0];
  }

  saveDate() async {
    try {
      rm = ReminderModel(days: _days, times: _times, id: id, isAwrad: true);
      await deleteNotification();
      await box.add(rm);
      toggelAlarmOption();
      Get.snackbar("تم", "تم حفظ الإعدادات");
    } catch (e) {
      _handleError(e);
    }
  }

  deleteNotification({bool showNotification = false}) async {
    try {
      final vals = box.values.toList();
      final recur = vals.where((element) => element.id == id).toList().reversed;

      for (var item in recur) {
        final index = vals.indexOf(item);
        await box.deleteAt(index);
      }
      if (showNotification) {
        Get.snackbar("تم", "تم حذف التنبيه");
        _days = [];
        _times = [];
        rm = null;
        notifyListeners();
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void addDay(int index) {
    index += 1;
    if (_days.contains(index)) {
      _days.remove(index);
    } else {
      _days.add(index);
    }
    notifyListeners();
  }

  void addTime(int index) {
    if (_times.contains(index)) {
      _times.remove(index);
    } else {
      _times.add(index);
    }
    notifyListeners();
  }

  _handleError(e) {
    Get.snackbar("خطأ", "$e");
  }
}
