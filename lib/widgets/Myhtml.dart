import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

class MyHtml extends StatelessWidget {
  final String html;
  const MyHtml({Key key, this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final symbols = Provider.of<Map<String, dynamic>>(context);
    String newHtml = html;
    symbols.forEach((key, value) {
      newHtml = newHtml.replaceAll(key, value);
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Html(
        data: html,
        onLinkTap: (url) {},
        style: {
          "*": Style(fontFamily: "lotus"),
          '[style*="QCF_BSML"]': Style(fontFamily: "QCF_BSML"),
          '[style*="QCF2BSML"]': Style(fontFamily: "QCF2BSML"),
          '[style*="QCF2176"]': Style(fontFamily: "QCF2176"),
          '[style*="QCF2066"]': Style(fontFamily: "QCF2066"),
          '[style*="QCF2285"]': Style(fontFamily: "QCF2285"),
          '[style*="QCF2484"]': Style(fontFamily: "QCF2484"),
          '[style*="QCF2138"]': Style(fontFamily: "QCF2138"),
          '[style*="QCF2458"]': Style(fontFamily: "QCF2458"),
          '[style*="QCF2256"]': Style(fontFamily: "QCF2256"),
          '[style*="QCF2002"]': Style(fontFamily: "QCF2002"),
          '[style*="QCF2558"]': Style(fontFamily: "QCF2558"),
          '[style*="QCF2472"]': Style(fontFamily: "QCF2472"),
          '[style*="QCF2365"]': Style(fontFamily: "QCF2365"),
          '[style*="QCF2452"]': Style(fontFamily: "QCF2452"),
          '[style*="QCF2596"]': Style(fontFamily: "QCF2596"),
          '[style*="QCF2290"]': Style(fontFamily: "QCF2290"),
          '[style*="QCF2564"]': Style(fontFamily: "QCF2564"),
          '[style*="QCF2150"]': Style(fontFamily: "QCF2150"),
          '[style*="QCF2053"]': Style(fontFamily: "QCF2053"),
          '[style*="QCF2294"]': Style(fontFamily: "QCF2294"),
          '[style*="QCF2485"]': Style(fontFamily: "QCF2485"),
          '[style*="QCF2532"]': Style(fontFamily: "QCF2532"),
          '[style*="QCF2483"]': Style(fontFamily: "QCF2483"),
          '[style*="QCF_P119"]': Style(fontFamily: "QCF_P119"),
          '[style*="QCF2119"]': Style(fontFamily: "QCF2119"),
          '[style*="QCF2001"]': Style(fontFamily: "QCF2001"),
          '[style*="QCF2024"]': Style(fontFamily: "QCF2024"),
          '[style*="QCF2511"]': Style(fontFamily: "QCF2511"),
          '[style*="QCF2602"]': Style(fontFamily: "QCF2602"),
          '[style*="QCF2165"]': Style(fontFamily: "QCF2165"),
          '[style*="QCF2018"]': Style(fontFamily: "QCF2018"),
          '[style*="QCF2090"]': Style(fontFamily: "QCF2090"),
          '[style*="QCF2582"]': Style(fontFamily: "QCF2582"),
          '[style*="QCF2117"]': Style(fontFamily: "QCF2117"),
          '[style*="QCF2603"]': Style(fontFamily: "QCF2603"),
          '[style*="QCF2474"]': Style(fontFamily: "QCF2474"),
          '[style*="QCF2312"]': Style(fontFamily: "QCF2312"),
          '[style*="QCF2377"]': Style(fontFamily: "QCF2377"),
          '[style*="QCF2440"]': Style(fontFamily: "QCF2440"),
          '[style*="QCF2305"]': Style(fontFamily: "QCF2305"),
          '[style*="QCF2208"]': Style(fontFamily: "QCF2208"),
          '[style*="QCF2367"]': Style(fontFamily: "QCF2367"),
          '[style*="QCF2187"]': Style(fontFamily: "QCF2187"),
          '[style*="QCF2467"]': Style(fontFamily: "QCF2467"),
          '[style*="QCF2590"]': Style(fontFamily: "QCF2590"),
          '[style*="QCF2243"]': Style(fontFamily: "QCF2243"),
          '[style*="QCF2072"]': Style(fontFamily: "QCF2072"),
          '[style*="QCF2453"]': Style(fontFamily: "QCF2453"),
          '[style*="QCF2249"]': Style(fontFamily: "QCF2249"),
          '[style*="QCF2151"]': Style(fontFamily: "QCF2151"),
          '[style*="QCF2518"]': Style(fontFamily: "QCF2518"),
          '[style*="QCF2316"]': Style(fontFamily: "QCF2316"),
          '[style*="QCF2042"]': Style(fontFamily: "QCF2042"),
          '[style*="QCF2207"]': Style(fontFamily: "QCF2207"),
          '[style*="QCF2451"]': Style(fontFamily: "QCF2451"),
          '[style*="QCF2329"]': Style(fontFamily: "QCF2329"),
          '[style*="QCF2052"]': Style(fontFamily: "QCF2052"),
        },
      ),
    );
  }
}
