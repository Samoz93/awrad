import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/awrad/AwradVM.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/widgets/AlarmOption/AlarmOptions.dart';
import 'package:awrad/widgets/AlarmOption/ExpansionVM.dart';
import 'package:awrad/models/AwradTypesModel.dart';
import 'package:awrad/widgets/InstaAudioPlay/InstaAudioPlay.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyErrorWidget.dart';
import 'package:awrad/widgets/MyScf.dart';
import 'package:awrad/widgets/Myhtml.dart';
import 'package:awrad/widgets/PdfPage/PdfPage.dart';
import 'package:awrad/widgets/ShareWidget.dart/ShareWidget.dart';
import 'package:flutter/material.dart';
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
                    leading:
                        wrd.isPDF ? Icon(Icons.book) : Icon(Icons.text_format),
                    onExpansionChanged: (v) async {
                      // final _ser = Get.find<NotificationService>();
                      // await _ser.testRemoveAll();
                      // final pending = await flutterLocalNotificationsPlugin
                      //     .pendingNotificationRequests();
                      // log(pending.length.toString());
                      // log(pending
                      //     .map((e) =>
                      //         "${e.body} ${e.id} ${e.payload} ${e.title}\n")
                      //     .toString());
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
                          wrd.isPDF
                              ? InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PdfPage(
                                        link: wrd.pdfLink,
                                        name: wrd.wrdName,
                                        uid: wrd.uid,
                                      ),
                                    ));
                                  },
                                  child: Image.asset(
                                    "assets/book.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                )
                              : MyHtml(html: wrd.wrdDesc),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AlarmOptions(wrd: wrd),
                              wrd.hasSound && !exVm.showAlaramOption
                                  ? Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InstaAudioPlay(
                                            url: wrd.link,
                                            player: model.player,
                                          ),
                                        ),
                                        _getShareWidget(wrd)
                                      ],
                                    )
                                  : _getShareWidget(wrd)
                            ],
                          ),
                        ],
                      ),
                    ],
                    title: RichText(
                      text: TextSpan(
                        text: "${index + 1} - ",
                        style: AppThemes.wrdTitleTextStyle3,
                        children: [
                          TextSpan(
                            text: wrd.wrdName,
                            style: AppThemes.wrdTitleTextStyle2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
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

  _getShareWidget(WrdModel wrd) {
    return ShareWidget(
      name: wrd.wrdName,
      html: wrd.wrdDesc,
      isPdf: wrd.isPDF,
      link: wrd.pdfLink,
      uid: wrd.uid,
    );
  }
}
