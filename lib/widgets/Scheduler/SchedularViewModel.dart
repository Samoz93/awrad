import 'dart:developer';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:stacked/stacked.dart';

class SchedularViewModel extends BaseViewModel {
  List<int> times = List.generate(8, (index) => index);
  List<int> days = List.generate(8, (index) => index);

  List<List<int>> _allList = List.generate(8, (index) => []);

  addTimes(int day, int time) {
    _allList[day].contains(time)
        ? _allList[day].remove(time)
        : _allList[day].add(time);

    log(_allList.toString());
    notifyListeners();
  }

  bool isChecked(int day, int time) {
    return _allList[day].contains(time);
  }

  String getDay(int day) {
    return daysOfWeek2[day - 1].name;
  }

  String getTime(int time) {
    return azanTimes[time - 1].name;
  }
}
