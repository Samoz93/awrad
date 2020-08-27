import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:stacked/stacked.dart';

class Schedular2Vm extends BaseViewModel {
  int _selectedDay = 1;
  int get selectedDay => _selectedDay;
  int get selectedIndex => _selectedDay - 1;
  List<List<dynamic>> _allList = List.generate(7, (index) => []);

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

    // final str = _allList[selectedIndex]
    //     .toString()
    //     .replaceAll("[", "")
    //     .replaceAll("]", "");
    // log(str);
    // final lst = str.split(",");
    // log(lst[0]);
    notifyListeners();
  }

  isTimeSelected(String type) {
    return _allList[selectedIndex].contains(type);
  }

  getPercentage(int day) {
    final index = day - 1;
    return _allList[index].length / azanTimes.length;
  }
}
