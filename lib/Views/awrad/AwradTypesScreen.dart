import 'package:awrad/Views/awrad/AwradListScreen.dart';
import 'package:awrad/models/AwradTypesModel.dart';
import 'package:awrad/services/AwradService.dart';
import 'package:awrad/widgets/AwradBtn.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';

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
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    AwradBtn(
                      txt: snapshot.data[index].typeName,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AwradListScreen(
                              type: snapshot.data[index],
                            ),
                          ),
                        );
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
