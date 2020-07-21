import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/services/AwradService.dart';
import 'package:stacked/stacked.dart';

class AwradVM extends BaseViewModel {
  final ser = AwradService();

  List<WrdModel> _awrad;
  List<WrdModel> get awrad => _awrad;
  List<String> _selectedList = [];
  List<String> get selectedList => _selectedList;

  bool _showDays = false;
  bool get showAlaramOption => _showDays;
  toggelAlarmOption() {
    _showDays = !_showDays;
    notifyListeners();
  }

  addDay(day) {
    if (_selectedList.contains(day))
      _selectedList.remove(day);
    else
      _selectedList.add(day);

    notifyListeners();
  }

  fetchData(String type) {
    runBusyFuture(_getData(type));
  }

  _getData(type) async {
    _awrad = await ser.allAwrad(type);
  }
}
