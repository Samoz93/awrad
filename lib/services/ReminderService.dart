import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/main.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/NotificationService.dart';
import 'package:get/get.dart';

class ReminderService {
  final _notiSer = Get.find<NotificationService>();
  saveReminder(ReminderModel rm) async {
    await deleteDuplicatedReminders(rm.id);
    await reminderBox.add(rm);
    _notiSer.scheduleWrdNotification(rm);
  }

  testDeleteAll() async {
    await reminderBox.clear();
  }

  ReminderModel getReminder(WrdModel wrd, {bool isAwrad = true}) {
    ReminderModel rm = ReminderModel(
      id: wrd.uid,
      type: wrd.wrdType,
      wrdName: wrd.wrdName,
      wrdText: wrd.wrdDesc,
      isAwrad: isAwrad,
      days: [],
      times: [],
    );

    try {
      final data = reminderBox.values
          .firstWhere((element) => element.id == wrd.uid, orElse: () => null);
      if (data != null) {
        rm = data;
      }
      return rm;
    } catch (e) {
      return rm;
    }
  }

  ReminderModel getReminderById(String uid) {
    final data = reminderBox.values
        .firstWhere((element) => element.id == uid, orElse: () => null);
    return data;
  }

  bool hasReminder(uid) {
    final data = reminderBox.values
        .firstWhere((element) => element.id == uid, orElse: () => null);
    return data != null;
  }

  List<ReminderModel> get allReminders {
    return reminderBox.keys.map((e) => reminderBox.get(e)).toList();
  }

  deleteDuplicatedReminders(String uid, {bool showNotification = false}) async {
    final vals = reminderBox.values.toList();
    final recur = vals.where((element) => element.id == uid).toList().reversed;
    for (var item in recur) {
      final index = vals.indexOf(item);
      await reminderBox.deleteAt(index);
    }
    await _notiSer.cancelSchedule(uid);
    if (showNotification) {
      showSnackBar("تم", "تم حذف التنبيه");
    }
  }

  String getAzanReminderState(String azanType) {
    return mainBox.get(azanType, defaultValue: "on");
  }

  _setAzanReminderState(String azanType, String value) async {
    await mainBox.put(azanType, value);
  }

  Future<void> toggleAzanState(String azanType) async {
    final crntState = getAzanReminderState(azanType);
    if (crntState == "on") await _setAzanReminderState(azanType, "silent");
    if (crntState == "silent") await _setAzanReminderState(azanType, "off");
    if (crntState == "off") await _setAzanReminderState(azanType, "on");
    _notiSer.scheduleAzanTimes();
  }
}
