import 'package:adhan/adhan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;

getSvgIcon(String name, {double size, Color color}) {
  return SvgPicture.asset(
    "assets/icons/$name.svg",
    width: size,
    height: size,
    // color: color,
  );
}

Map<String, dynamic> getMap(data) {
  return Map<String, dynamic>.from(data);
}

Size getTextSize(String text, TextStyle style, double maxWidth) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      // maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: maxWidth);
  return textPainter.size;
}

double getTextSize2(String text, double fontSize) {
  final constraints = BoxConstraints(
    maxWidth: 100.0, // maxwidth calculated
    minWidth: 0.0,
  );

  RenderParagraph renderParagraph = RenderParagraph(
    TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
      ),
    ),
    textDirection: TextDirection.rtl,
    maxLines: 1,
  );
  renderParagraph.layout(constraints);
  double textlen = renderParagraph.getMaxIntrinsicHeight(800);
  return textlen;
}

List<String> get daysOfWeek {
  return daysOfWeekInt.map((e) {
    final date = DateTime(2020, 1, e + 5);
    return intl.DateFormat('EE', "ar").format(date);
  }).toList();
}

List<int> get daysOfWeekInt {
  return List.generate(7, (index) => index + 1);
}

List<int> get timesOfDayInt {
  return List.generate(7, (index) => index);
}

final List<AzanTimeClass> _times = [
  AzanTimeClass("الفجر", Prayer.fajr),
  AzanTimeClass("الضحى", Prayer.sunrise),
  AzanTimeClass("الظهر", Prayer.dhuhr),
  AzanTimeClass("العصر", Prayer.asr),
  AzanTimeClass("المغرب", Prayer.maghrib),
  AzanTimeClass("العشاء", Prayer.isha),
  AzanTimeClass("ثلث الليل", Prayer.none),
];
List<AzanTimeClass> get azanTimes => _times;
List<String> get timesOfDay {
  return timesOfDayInt.map((e) {
    return _times[e].name;
  }).toList();
}

extension timerMethodes on DateTime {
  String get myTime => intl.DateFormat.jms().format(this);
  String get myTimeNoSeconds => intl.DateFormat.jm().format(this);
}

class AzanTimeClass {
  String name;
  Prayer type;
  AzanTimeClass(this.name, this.type);
}
