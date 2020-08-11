import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:awrad/services/ReminderService.dart';
import 'package:stacked/stacked.dart';

class ReminderWidgetVm extends BaseViewModel {
  ReminderModel _rmd;
  final _ser = ReminderService();
  ReminderWidgetVm(String uid) {
    _rmd = _ser.getReminderById(uid);
    print(_rmd);
  }

  ReminderModel get reminder => _rmd;
  List<String> get daysString {
    if (_rmd.days.length == daysOfWeek2.length) return ["جميع ايام الاسبوع"];
    return _rmd.days
        .map((e) => daysOfWeek2.firstWhere((g) => g.isTodayDate(e)).name)
        .toList();
  }

  List<String> get timeString {
    final weekDay = timesOfDay;
    if (_rmd.times.length == weekDay.length) return ["جميع اوقات اليوم"];
    return _rmd.times.map((e) => weekDay[e]).toList();
  }
}
