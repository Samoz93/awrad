import 'dart:async';
import 'package:stacked/stacked.dart';
import '../../Consts/ConstMethodes.dart';

class TimerVm extends BaseViewModel {
  TimerVm() {
    _setTimer();
  }
  _setTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final formatted = now.myTime;
      _time = formatted;
      notifyListeners();
    });
  }

  String _time = "";
  String get time => _time;
}
