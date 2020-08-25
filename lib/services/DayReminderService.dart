class DayReminderService {
  List<String> convertListToString(List<List<int>> list) {
    return list.map((e) => e.toString()).toList();
  }

  List<List<int>> convertStringToList(List<String> list) {
    return list.map((e) => e.split(",").map((e) => int.parse(e))).toList();
  }
}
