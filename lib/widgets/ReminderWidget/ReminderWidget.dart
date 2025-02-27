import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/quran/QuranNewScreen.dart';
import 'package:awrad/widgets/InstaAudioPlay/InstaAudioPlay.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/Myhtml.dart';
import 'package:awrad/widgets/PdfPage/PdfPage.dart';
import 'package:awrad/widgets/ReminderWidget/ReminderWidgetVM.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class ReminderWidget extends StatefulWidget {
  final String uid;
  final Function deleteFunction;
  const ReminderWidget({Key key, this.uid, @required this.deleteFunction})
      : super(key: key);

  @override
  _ReminderWidgetState createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
  @override
  void dispose() {
    super.dispose();
    player?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReminderWidgetVm>.reactive(
      viewModelBuilder: () => ReminderWidgetVm(widget.uid),
      builder: (ctx, model, ch) {
        return model.isBusy
            ? LoadingWidget()
            : InkWell(
                onTap: () {
                  if (model.reminder.isAwrad) {
                    if (model.reminder.isPdf) {
                      return Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => PdfPage(
                          link: model.reminder.pdfLink,
                          name: model.reminder.wrdName,
                          uid: model.reminder.id,
                        ),
                      ));
                    }
                    Get.dialog(
                      Dialog(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              model.reminder.hasSound
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InstaAudioPlay(
                                        wrdType: "أوراد",
                                        url: model.reminder.link,
                                        wrdName: model.reminder.wrdName,
                                        player: player,
                                      ),
                                    )
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: MyHtml(
                                  html: model.reminder.wrdText,
                                  // style: {
                                  //   "*": Style(
                                  //     textAlign: TextAlign.center,
                                  //   ),
                                  // },
                                  // shrinkWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuranNewScreen(
                        suraName:
                            model.reminder.isJuz ? '' : model.reminder.wrdName,
                        juzNumber: model.reminder.isJuz
                            ? model.reminder.juzNumber
                            : -1,
                      ),
                    ));
                },
                child: Dismissible(
                  key: Key(model.reminder.id),
                  onDismissed: (dir) {
                    widget.deleteFunction();
                  },
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: AppColors.deleteColor,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "حذف",
                          textAlign: TextAlign.start,
                          style: AppThemes.deleteInfoTextStyle,
                        ),
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return confirmMessage(
                        "هل أنت متأكد من حذفك لهذا التنبيه ؟");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black26,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(model.reminder.isAwrad
                                        ? model.reminder.isPdf
                                            ? Icons.book
                                            : Icons.text_format
                                        : Icons.library_books),
                                  ),
                                  Text(
                                    !model.reminder.isAwrad &&
                                            model.reminder.isJuz
                                        ? "الجزء ${model.reminder.juzNumber}"
                                        : model.reminder.wrdName,
                                    style: AppThemes.wrdTitleTextStyle,
                                  ),
                                ],
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "سيتم التذكير في : ${model.daysString}",
                                ),
                              ),
                              // FittedBox(
                              //   fit: BoxFit.scaleDown,
                              //   child: Text(
                              //     "سيتم تذكيرك بعد : ${model.timeString}",
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (await confirmMessage(
                                "هل أنت متأكد من حذفك لهذا التنبيه ؟"))
                              widget.deleteFunction();
                          },
                          child: Icon(
                            Icons.alarm_off,
                            color: AppColors.deleteColor,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
