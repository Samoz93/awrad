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

Size getTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      // maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

double getTextSize2(String text, double fontSize) {
  final constraints = BoxConstraints(
    maxWidth: 800.0, // maxwidth calculated
    minHeight: 0.0,
    minWidth: 0.0,
  );

  RenderParagraph renderParagraph = RenderParagraph(
    TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
      ),
    ),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );
  renderParagraph.layout(constraints);
  double textlen =
      renderParagraph.getMinIntrinsicWidth(fontSize).ceilToDouble();
}

List<String> get daysOfWeek {
  final List<String> lst = [];
  for (var i = 0; i < 7; i++) {
    final date = DateTime(2000, 1, i);
    lst.add(intl.DateFormat('EE', "ar").format(date));
  }
  return lst;
}
