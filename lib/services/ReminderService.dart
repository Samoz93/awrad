import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/NotificationService.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ReminderService {
  // final _repo = Get.find<LocalRepoSerivce>();
  final _reminderBox = Hive.box<ReminderModel>(REMINDER_BOX);
  final _mainBox = Hive.box(MAINBOX);
  final _notiSer = Get.find<NotificationService>();
  saveReminder(ReminderModel rm) async {
    await deleteDuplicatedReminders(rm.id);
    final int lastId = _mainBox.get(LAST_SAVED_ID, defaultValue: 10) + 1;
    await _reminderBox.add(rm..notifId = lastId);
    _notiSer.scheduleNotification(rm);
  }

  testDeleteAll() async {
    await _reminderBox.clear();
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
      final data =
          _reminderBox.values.firstWhere((element) => element.id == wrd.uid);
      if (data != null) {
        rm = data;
      }
      return rm;
    } catch (e) {
      return rm;
    }
  }

  List<ReminderModel> get allReminders {
    return _reminderBox.keys.map((e) => _reminderBox.get(e)).toList();
  }

  deleteDuplicatedReminders(String uid, {bool showNotification = false}) async {
    final vals = _reminderBox.values.toList();
    final recur = vals.where((element) => element.id == uid).toList().reversed;
    int notiId = 0;
    for (var item in recur) {
      notiId = item.notifId;
      final index = vals.indexOf(item);
      await _reminderBox.deleteAt(index);
    }
    _notiSer.cancelSchedule(notiId);
    if (showNotification) {
      Get.snackbar("تم", "تم حذف التنبيه");
    }
  }

  String getAzanReminderState(String azanType) {
    return _mainBox.get(azanType, defaultValue: "on");
  }

  _setAzanReminderState(String azanType, String value) async {
    await _mainBox.put(azanType, value);
  }

  Future<void> toggleAzanState(String azanType) async {
    final crntState = getAzanReminderState(azanType);
    if (crntState == "on") await _setAzanReminderState(azanType, "silent");
    if (crntState == "silent") await _setAzanReminderState(azanType, "off");
    if (crntState == "off") await _setAzanReminderState(azanType, "on");
  }
}
