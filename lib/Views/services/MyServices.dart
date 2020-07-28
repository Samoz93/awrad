import 'package:awrad/Views/services/MyMasbaha.dart';
import 'package:awrad/Views/services/MyQubla.dart';
import 'package:awrad/Views/services/MySalat.dart';
import 'package:awrad/widgets/AwradBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyServices extends StatelessWidget {
  MyServices({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      // width: 200,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[...route.map((e) => _getCard(e, context))],
      ),
    );
  }

  final route = [
    {"route": MyQubla(), "name": "البوصلة"},
    {"route": MySalat(), "name": "اوقات الصلاة"},
    {"route": MyMasbaha(), "name": "المسبحة"},
  ];

  _getCard(data, BuildContext context) {
    final svgName = data['route'];
    return AwradBtn(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => data['route'],
        ));
      },
      txt: data["name"],
      icon: SvgPicture.asset("assets/icons/$svgName.svg"),
    );
  }
}
