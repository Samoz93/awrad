import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/ReminderService.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class SavedAwradVM extends BaseViewModel {
  final ReminderService _ser = Get.find<ReminderService>();
  List<ReminderModel> _remindres;
  // List<ReminderModel> get reminders => _remindres;
  SavedAwradVM() {
    // _ser.testDeleteAll();
    _init();
  }
  _init() {
    _remindres = _ser.allReminders;
    notifyListeners();
  }

  int _selectedTap = 0;
  int get selectedTap => _selectedTap;
  set selectedTap(val) {
    _selectedTap = val;
    notifyListeners();
  }

  _getTodayNumber() {
    return DateTime.now().weekday;
  }

  todayName() {
    return daysOfWeek[_getTodayNumber() - 1];
  }

  List<ReminderModel> get _todaysReminder {
    return _remindres
        .where((element) => element.days.contains(_getTodayNumber()))
        .toList();
  }

  List<ReminderModel> get _awradData {
    if (selectedTap == 0)
      return _todaysReminder;
    else
      return _remindres;
  }

  List<ReminderModel> get awradData {
    return _awradData.where((element) => element.isAwrad).toList();
  }

  List<ReminderModel> get quranData {
    return _awradData.where((element) => element.isAwrad).toList();
  }

  deleteNotification(String id) async {
    await _ser.deleteDuplicatedReminders(id, showNotification: false);
    _init();
  }
}
