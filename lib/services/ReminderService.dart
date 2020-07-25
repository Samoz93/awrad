import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ReminderService {
  // final _repo = Get.find<LocalRepoSerivce>();
  final reminderBox = Hive.box<ReminderModel>(REMINDER_BOX);

  saveReminder(ReminderModel rm) async {
    await deleteDuplicatedReminders(rm.id);
    await reminderBox.add(rm);
  }

  ReminderModel getReminder(String uid, {bool isAwrad = true}) {
    try {
      ReminderModel rm =
          ReminderModel(id: uid, isAwrad: isAwrad, days: [], times: []);
      final data =
          reminderBox.values.firstWhere((element) => element.id == uid);
      if (data != null) {
        rm = data;
      }
      return rm;
    } catch (e) {
      return ReminderModel(id: uid, isAwrad: isAwrad, days: [], times: []);
    }
  }

  deleteDuplicatedReminders(String uid, {bool showNotification = false}) async {
    final vals = reminderBox.values.toList();
    final recur = vals.where((element) => element.id == uid).toList().reversed;

    for (var item in recur) {
      final index = vals.indexOf(item);
      await reminderBox.deleteAt(index);
    }
    if (showNotification) {
      Get.snackbar("تم", "تم حذف التنبيه");
    }
  }
}
