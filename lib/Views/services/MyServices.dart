import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/services/MyMasbaha.dart';
import 'package:awrad/Views/services/MyQubla.dart';
import 'package:awrad/Views/services/MySalat.dart';
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
    final media = MediaQuery.of(context).size;
    final svgName = data['route'];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => data['route'],
        ));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: media.height * 0.15,
        width: media.width * 0.6,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: AppThemes.linearPointer,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  color: Colors.black38,
                  offset: Offset(0.6, -1.0))
            ]),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                data["name"],
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SvgPicture.asset("assets/icons/$svgName.svg"),
            ],
          ),
        ),
      ),
    );
  }
}
