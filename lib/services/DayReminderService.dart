import 'dart:developer';

import 'package:awrad/Consts/ConstMethodes.dart';

class DayReminderService {
  static convertToListOfString(List<List<dynamic>> _allList) {
    final List<String> lst = _allList
        .map((e) => e.toString().replaceAll("[", "").replaceAll("]", ""))
        .toList();
    return lst;
  }

  static List<List<dynamic>> convertToListOfList(List<String> lst) {
    if (lst == null) return daysOfWeek2.map((e) => []).toList();
    final newLst = lst.map((e) {
      if (e.isEmpty) return [];
      return e.split(",").map((e) => e.replaceAll(" ", '')).toList();
    }).toList();
    log(newLst.toString());
    return newLst;
  }
}
