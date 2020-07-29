import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/ReminderService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class ExpansionVM extends BaseViewModel {
  final WrdModel wrd;
  final isAwrad;
  final _ser = Get.find<ReminderService>();
  ReminderModel _rm;
  ExpansionVM({@required this.wrd, this.isAwrad = true}) {
    _init();
  }
  _init() {
    _rm = _ser.getReminder(wrd, isAwrad: isAwrad);
    notifyListeners();
  }

  bool get hasReminder => _rm.hasReminder;
  ReminderModel get reminder => _rm;

  bool _showAlaramOption = false;
  bool get showAlaramOption => _showAlaramOption;
  toggelAlarmOption() {
    _showAlaramOption = !_showAlaramOption;
    notifyListeners();
  }

  List<bool> get selectionBool {
    return daysOfWeekInt
        .map((e) => _rm == null ? false : _rm.days.contains(e))
        .toList();
  }

  List<bool> get selectionBoolTimes {
    return timesOfDayInt
        .map((e) => _rm == null ? false : _rm.times.contains(e))
        .toList();
  }

  // String getDasyName(int day) {
  //   return daysOfWeek[day];
  // }

  saveDate() async {
    try {
      if (!_rm.hasReminder) {
        showSnackBar("لايمكن المتابعة",
            "يرجى اختيار يوم واحد وتاريخ واحد على الاقل لكي يتم حفظ التنبيه",
            isErr: true);
        return;
      }
      await _ser.saveReminder(_rm);
      toggelAlarmOption();
      showSnackBar("تم", "تم حفظ الإعدادات");
    } catch (e) {
      _handleError(e);
    }
  }

  void addDay(int index) {
    if (_rm.days.contains(index)) {
      _rm.days.remove(index);
    } else {
      _rm.days.add(index);
    }
    notifyListeners();
  }

  void addTime(int index) {
    if (_rm.times.contains(index)) {
      _rm.times.remove(index);
    } else {
      _rm.times.add(index);
    }
    notifyListeners();
  }

  _handleError(e) {
    showSnackBar("خطأ", "$e", isErr: true);
  }

  Future<void> deleteNotification(String uid, {bool showNotification}) async {
    try {
      await _ser.deleteDuplicatedReminders(uid, showNotification: true);
      _init();
    } catch (e) {
      _handleError(e);
    }
  }
}
