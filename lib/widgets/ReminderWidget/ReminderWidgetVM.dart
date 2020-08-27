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
    final x = _rmd.nDay;
    if (x.length == daysOfWeek2.length) return ["جميع ايام الاسبوع"];
    return x.map((e) => e.name).toList();
  }

  // List<String> get timeString {
  //   final weekDay = timesOfDay;
  //   if (_rmd.times.length == weekDay.length) return ["جميع اوقات اليوم"];
  //   return _rmd.times.map((e) => weekDay[e]).toList();
  // }
}
