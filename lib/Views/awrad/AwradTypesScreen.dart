import 'package:awrad/Views/Library/MyLibrary.dart';
import 'package:awrad/models/AwradTypesModel.dart';
import 'package:awrad/services/AwradService.dart';
import 'package:awrad/widgets/AwradBtn.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';

import 'AwradListScreen.dart';

class AwradTypesScreen extends StatelessWidget {
  AwradTypesScreen({Key key}) : super(key: key);

  final ser = AwradService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AwradTypesModel>>(
      future: ser.awradType,
      builder: (BuildContext context,
          AsyncSnapshot<List<AwradTypesModel>> snapshot) {
        if (snapshot.hasData)
          return Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    children: <Widget>[
                      AwradBtn(
                        txt: "مكتبة التصوف",
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => MyLibrary()),
                          );
                        },
                      ),
                      Divider(
                        thickness: 2,
                      )
                    ],
                  );
                }
                return Column(
                  children: <Widget>[
                    AwradBtn(
                      txt: snapshot.data[index - 1].typeName,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AwradListScreen(
                            type: snapshot.data[index - 1],
                          ),
                        ));
                      },
                    ),
                  ],
                );
              },
            ),
          );
        return LoadingWidget();
      },
    );
  }
}
