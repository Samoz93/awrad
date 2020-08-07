import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class MyHtml extends StatelessWidget {
  final String html;
  const MyHtml({Key key, this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      onLinkTap: (url) {},
      style: {
        "*": Style(textAlign: TextAlign.right),
        ".ql-font-monospace": Style(
          fontFamily: "uth",
        ),
      },
    );
  }
}
