import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:hive/hive.dart';

class LocalRepoSerivce {
  final mainBox = Hive.box(MAINBOX);
  final reminderBox = Hive.box<ReminderModel>(REMINDER_BOX);

  saveQuran(json) {}
  saveReminder(ReminderModel reminder) {}

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
      //TODO HANDLE ERROR
      return null;
    }
  }
}
