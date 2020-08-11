import 'dart:typed_data';

import 'package:awrad/Views/quran/QuranFahras.dart';
import 'package:awrad/Views/quran/TajweedScreen.dart';
import 'package:awrad/base/locator.dart';
import 'package:awrad/widgets/AwradBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class QuranMainScreen extends StatelessWidget {
  const QuranMainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          AwradBtn(
            txt: "القرآن الكريم",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuranFahras(),
                ),
              );
            },
          ),
          AwradBtn(
            txt: "آداب القرآن",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TajweedScreen(),
                ),
              );
            },
          ),
          AwradBtn(
            txt: "test",
            onPressed: () async {
              var vibrationPattern = Int64List(6);
              vibrationPattern[0] = 100;
              vibrationPattern[1] = 300;
              vibrationPattern[2] = 100;
              vibrationPattern[3] = 300;
              vibrationPattern[4] = 100;
              vibrationPattern[5] = 400;

              var androidPlatformChannelSpecifics = AndroidNotificationDetails(
                'AzanChannel',
                'قناة الأذان',
                'هذه القناة مختصة للتنبيه بأوقات الصلاة',
                // playSound: true,
                enableVibration: true,
                vibrationPattern: vibrationPattern,
                sound: RawResourceAndroidNotificationSound("adan"),
              );
              final title = "وقت ";
              final message = 'حان الآن موعد صلاة';

              var iOSPlatformChannelSpecifics = IOSNotificationDetails(
                sound: "ggg.aiff",
              );
              var platformChannelSpecifics = NotificationDetails(
                  androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
              await flutterLocalNotificationsPlugin.show(
                9,
                title,
                message,
                platformChannelSpecifics,
                payload: "azan",
              );
            },
          ),
        ],
      ),
    );
  }
}
