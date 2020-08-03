import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
  return List.generate(7, (index) => index);
}

List<int> get timesOfDayInt {
  return List.generate(7, (index) => index);
}

final List<AzanTimeClass> _times = [
  AzanTimeClass("ثلث الليل", "Midnight", false),
  AzanTimeClass("الفجر", "Fajr", true),
  AzanTimeClass("الضحى", "Sunrise", false),
  AzanTimeClass("الظهر", "Dhuhr", true),
  AzanTimeClass("العصر", "Asr", true),
  AzanTimeClass("المغرب", "Maghrib", true),
  AzanTimeClass("العشاء", "Isha", true),
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
  String type;
  bool isAdan;
  AzanTimeClass(this.name, this.type, this.isAdan);
}

Future<bool> confirmMessage(String content) async {
  final x = await Get.dialog<bool>(
      AlertDialog(
        title: Center(child: Text("تأكيد ")),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text("تأكيد"),
            onPressed: () {
              Get.back(
                result: true,
              );
            },
          ),
          FlatButton(
              child: Text("إلغاء"),
              onPressed: () {
                Get.back(
                  result: false,
                );
              })
        ],
      ),
      useRootNavigator: false);
  return x != null && x == true;
}

getData(String path, String baseUrl) async {
  final _dio = Dio();
  const _extra = <String, dynamic>{};
  final queryParameters = <String, dynamic>{};
  final _data = <String, dynamic>{};
  final Response<Map<String, dynamic>> _result = await _dio.request(path,
      queryParameters: queryParameters,
      options: RequestOptions(
          method: 'GET',
          headers: <String, dynamic>{},
          extra: _extra,
          baseUrl: baseUrl),
      data: _data);
  return _result.data;
}

showSnackBar(title, message, {isErr = false}) {
  Get.snackbar(title, message,
      backgroundColor: isErr
          ? AppColors.deleteColor.withOpacity(0.3)
          : AppColors.addColor.withOpacity(0.3),
      barBlur: 5);
}
