import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/DayReminderService.dart';
import 'package:awrad/services/ReminderService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class ExpansionVM extends BaseViewModel {
  ExpansionVM({@required this.wrd, this.isAwrad = true}) {
    _init();
  }
  _init() {
    _rm = _ser.getReminder(wrd, isAwrad: isAwrad);
    _allList = DayReminderService.convertToListOfList(_rm.daysNew);
    notifyListeners();
  }

  int _selectedDay = 1;
  int get selectedDay => _selectedDay;
  int get selectedIndex => _selectedDay - 1;

  set selectedDay(val) {
    _selectedDay = val;
    notifyListeners();
  }

  List<bool> get selectionBoolTimes =>
      azanTimes.map((e) => _allList[selectedIndex].contains(e.type)).toList();
  addTimes(String time) {
    _allList[selectedIndex].contains(time)
        ? _allList[selectedIndex].remove(time)
        : _allList[selectedIndex].add(time);
    notifyListeners();
  }

  isTimeSelected(String type) {
    return _allList[selectedIndex].contains(type);
  }

  getPercentage(int day) {
    final index = day - 1;
    return _allList[index].length / azanTimes.length;
  }

  final WrdModel wrd;
  final isAwrad;
  final _ser = Get.find<ReminderService>();
  ReminderModel _rm;

  List<List<dynamic>> _allList;

  bool get hasReminder => _ser.hasReminder(_rm.id);
  ReminderModel get reminder => _rm;

  bool _showAlaramOption = false;
  bool get showAlaramOption => _showAlaramOption;
  toggelAlarmOption() {
    _showAlaramOption = !_showAlaramOption;
    notifyListeners();
  }

  // List<bool> get selectionBool {
  //   return daysOfWeek2
  //       .map((e) => _rm == null ? false : _rm.days.contains(e.dateWeek))
  //       .toList();
  // }

  // String getDasyName(int day) {
  //   return daysOfWeek[day];
  // }

  saveDate() async {
    try {
      bool isValid = false;
      _allList.forEach((element) {
        if (element.isNotEmpty) isValid = true;
      });

      if (!isValid) {
        showSnackBar("لايمكن المتابعة",
            "يرجى اختيار يوم واحد وتاريخ واحد على الاقل لكي يتم حفظ التنبيه",
            isErr: true);
        return;
      }
      _rm.daysNew = DayReminderService.convertToListOfString(_allList);
      await _ser.saveReminder(_rm);
      toggelAlarmOption();
      showSnackBar("تم", "تم حفظ الإعدادات");
    } catch (e) {
      _handleError(e);
    }
  }

  // void addDay(int index) {
  //   final day = daysOfWeek2[index];
  //   if (_rm.days.contains(day.dateWeek)) {
  //     _rm.days.remove(day.dateWeek);
  //   } else {
  //     _rm.days.add(day.dateWeek);
  //   }
  //   notifyListeners();
  // }

  // void addTime(int index) {
  //   if (_rm.times.contains(index)) {
  //     _rm.times.remove(index);
  //   } else {
  //     _rm.times.add(index);
  //   }
  //   notifyListeners();
  // }

  _handleError(e) {
    showSnackBar("خطأ", "$e", isErr: true);
  }

  Future<void> deleteThisReminder() async {
    await deleteNotification(_rm.id, showNotification: true);
    toggelAlarmOption();
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
