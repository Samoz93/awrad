import 'dart:developer';

class DayReminderService {
  List<String> convertListToString(List<List<int>> list) {
    return list.map((e) {
      final x = e.toString();
      log(x);
      return x;
    }).toList();
  }

  List<List<int>> convertStringToList(List<String> list) {
    return list.map((e) => e.split(",").map((e) => int.parse(e))).toList();
  }
}
