import 'package:awrad/Views/quran/QuranFahras.dart';
import 'package:awrad/Views/quran/TajweedScreen.dart';
import 'package:awrad/widgets/AwradBtn.dart';
import 'package:flutter/material.dart';

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
            txt: "أحكام التجويد",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TajweedScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
