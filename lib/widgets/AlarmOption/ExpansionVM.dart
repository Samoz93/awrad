import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/DayReminderService.dart';
import 'package:awrad/services/ReminderService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class ExpansionVM extends BaseViewModel {
  ExpansionVM({@required this.wrd});
  init({isAwrad = true, bool isJuz = false, int juzPage = -1}) {
    _rm =
        _ser.getReminder(wrd, isAwrad: isAwrad, isJuz: isJuz, juzPage: juzPage);
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
      init();
    } catch (e) {
      _handleError(e);
    }
  }
}
