import 'dart:async';

import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerWidget extends StatefulWidget {
  TimerWidget({Key key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer timer;
  String time = "";
  @override
  void initState() {
    time = DateFormat.jms("ar").format(DateTime.now());

    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        time = DateFormat.jms("ar").format(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: AppThemes.timeTimerTextStyle,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
