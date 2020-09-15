import 'package:awrad/models/AdanModel.dart';
import 'package:awrad/services/AdhanApi.dart';
import 'package:awrad/services/ReminderService.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:vibration/vibration.dart';

class AdanVm extends BaseViewModel {
  final _ser = Get.find<AdhanApi>();
  final _reminderSer = Get.find<ReminderService>();

  AdanModel _allData;
  DateTime _selectedDate = DateTime.now();
  AdanData get adanData {
    return _allData.getAdan(_selectedDate);
  }

  String get selectedDate => DateFormat.yMd('en').format(_selectedDate);

  nextDate() {
    if (!canSetNext) return;
    _selectedDate = _selectedDate.add(Duration(days: 1));
    notifyListeners();
  }

  prevDay() {
    if (!canSetPrev) return;
    _selectedDate = _selectedDate.add(Duration(days: -1));
    notifyListeners();
  }

  bool get canSetPrev {
    final dif = _selectedDate.difference(DateTime.now()).inHours;
    return dif > 0;
  }

  bool get canSetNext {
    final sonra = _selectedDate.add(Duration(days: 1));
    return sonra.month == DateTime.now().month;
  }

  initData() async {
    setBusy(true);
    _allData = await _ser.adanTimes;
    setBusy(false);
  }

  String getAzanState(String azanType) {
    return _reminderSer.getAzanReminderState(azanType);
  }

  Future<void> toggleState(String type) async {
    Vibration.vibrate(duration: 500);
    await _reminderSer.toggleAzanState(type);
    notifyListeners();
  }
}
