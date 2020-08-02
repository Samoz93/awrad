import 'dart:developer';

import 'package:awrad/Views/awrad/AwradVM.dart';
import 'package:awrad/widgets/AlarmOption/AlarmOptions.dart';
import 'package:awrad/widgets/AlarmOption/ExpansionVM.dart';
import 'package:awrad/base/locator.dart';
import 'package:awrad/models/AwradTypesModel.dart';
import 'package:awrad/widgets/InstaAudioPlay/InstaAudioPlay.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyErrorWidget.dart';
import 'package:awrad/widgets/MyScf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stacked/stacked.dart';

class AwradListScreen extends StatelessWidget {
  final AwradTypesModel type;
  AwradListScreen({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: type.typeName,
      child: ViewModelBuilder<AwradVM>.reactive(
        builder: (context, model, ch) {
          if (model.isBusy) return LoadingWidget();
          if (model.hasError)
            return MyErrorWidget(
              err: model.modelError,
            );
          return ListView.builder(
            itemCount: model.awrad.length,
            itemBuilder: (BuildContext context, int index) {
              final wrd = model.awrad[index];
              return ViewModelBuilder<ExpansionVM>.reactive(
                  viewModelBuilder: () => ExpansionVM(wrd: wrd),
                  builder: (ctx, exVm, ch) {
                    if (exVm.hasError)
                      return MyErrorWidget(
                        err: exVm.modelError,
                      );
                    return ExpansionTile(
                      onExpansionChanged: (v) async {
                        // final _ser = Get.find<NotificationService>();
                        // await _ser.testRemoveAll();
                        final pending = await flutterLocalNotificationsPlugin
                            .pendingNotificationRequests();
                        log(pending.length.toString());
                        log(pending
                            .map((e) =>
                                "${e.body} ${e.id} ${e.payload} ${e.title}\n")
                            .toString());
                      },
                      initiallyExpanded: false,
                      subtitle: Align(
                        alignment: Alignment.bottomRight,
                        child: ch,
                      ),
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Html(data: wrd.wrdDesc),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                AlarmOptions(wrd: wrd),
                                wrd.hasSound && !exVm.showAlaramOption
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InstaAudioPlay(
                                          url: wrd.link,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ],
                      title: Text("${index + 1}-${wrd.wrdName}"),
                    );
                  });
            },
          );
        },
        fireOnModelReadyOnce: true,
        staticChild: Text(type.typeName),
        onModelReady: (vv) => vv.fetchData(type.type),
        viewModelBuilder: () => AwradVM(),
      ),
    );
  }
}
