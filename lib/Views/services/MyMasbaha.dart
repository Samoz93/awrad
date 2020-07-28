import 'package:awrad/models/AdanModel.dart';
import 'package:awrad/services/AdhanApi.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMasbaha extends StatelessWidget {
  MyMasbaha({Key key}) : super(key: key);
  final _ser = Get.find<AdhanApi>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _ser.todayAdan,
        builder: (BuildContext context, AsyncSnapshot<AdanData> snapshot) {
          if (ConnectionState.waiting == snapshot.connectionState)
            return LoadingWidget();
          return Text(snapshot.data.toJson().toString());
        },
      ),
    );
  }
}
