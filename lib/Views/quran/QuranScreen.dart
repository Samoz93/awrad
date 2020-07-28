import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/quran/QuranVm.dart';
import 'package:awrad/models/QuranModel.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class QuranScreen extends StatelessWidget {
  QuranScreen({Key key}) : super(key: key);
  // AudioPlayer audioPlayer = AudioPlayer();

  final vvm = QuranVM();
  @override
  Widget build(BuildContext context) {
    // final media = MediaQuery.of(context).size;
    final String wtTxt = "تحميل";
    return ViewModelBuilder<QuranVM>.reactive(
      viewModelBuilder: () => vvm,
      disposeViewModel: false,
      onModelReady: (vm) => vm.initQuarn(),
      builder: (ctx, model, ch) => Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _getTab(
                model.busy(model.quran) ? wtTxt : model.selectedSurah.name,
                "dd.png",
                () {
                  Get.bottomSheet(
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Container(
                        color: AppColors.adanNormal,
                        child: ListView(
                          children: <Widget>[
                            ...model.surahas.map(
                              (e) => InkWell(
                                onTap: () {
                                  vvm.selectedSurah = e;
                                  Get.back();
                                },
                                child: SuraWidget(
                                  sura: e,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              _getTab(
                  model.busy(model.quran)
                      ? wtTxt
                      : model.bookmarksCount > 0
                          ? "العلامات (${model.bookmarksCount > 0 ? model.bookmarksCount : ''})"
                          : "العلامات",
                  "dd.png", () {
                Get.bottomSheet(
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Container(
                      color: AppColors.adanNormal,
                      padding: EdgeInsets.all(8),
                      child: ListView(
                        children: <Widget>[
                          ...model.bookmarksInt.map(
                            (e) => InkWell(
                              onTap: () async {
                                Get.back();
                                await model.scrollController.scrollTo(
                                    index: e,
                                    duration: Duration(milliseconds: 700));
                              },
                              child:
                                  AyahWidget(aya: model.selectedSurah.ayahs[e]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, isMiddle: true),
            ],
          ),
          Flexible(
            flex: 1,
            child: model.busy(model.quran)
                ? LoadingWidget()
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        child: ScrollablePositionedList.builder(
                          itemScrollController: model.scrollController,
                          itemCount: model.selectedSurah.ayahs.length,
                          itemBuilder: (context, index) {
                            var e = model.selectedSurah.ayahs[index];
                            return Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(1, 1),
                                          blurRadius: 4)
                                    ],
                                    color: AppColors.surahColor,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          "${e.normalizeText} (${e.numberInSurah})",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            model.saveBookMark(index);
                                          },
                                          child: Image.asset(
                                            "assets/icons/bookmark.png",
                                            color: model.hasKey(index)
                                                ? AppColors.mainColorSelected
                                                : Colors.white,
                                          ))
                                    ],
                                  ),
                                ),
                                // Text(
                                //     "رقم الصفحة في القرآن الكريم (${e.page}) ${e.sajda ? '۩' : ''}"),
                                AudioPlayerWidget(url: e.audio)
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  _getTab(String txt, String img, Function onTap, {bool isMiddle = false}) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          //TODO use Sceenutil
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                "assets/icons/$img",
                fit: BoxFit.cover,
              ),
              Text(
                txt,
              ),
            ],
          ),
          decoration: BoxDecoration(
              color:
                  isMiddle ? AppColors.mainColor : AppColors.mainColorSelected),
        ),
      ),
    );
  }
}

class AudioPlayerWidget extends ViewModelWidget<QuranVM> {
  final PlayerState state;
  final String url;
  const AudioPlayerWidget({Key key, this.state, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context, QuranVM model) {
    //TODO FIX WITH STREAM
    Widget widget;
    if (model.currentUrl == url) {
      widget = StreamBuilder(
        stream: model.info,
        builder: (BuildContext context,
            AsyncSnapshot<RealtimePlayingInfos> snapshot) {
          double val = 0;
          if (snapshot.data == null || !snapshot.data.isPlaying) {
            return SizedBox();
          } else {
            if (snapshot.hasData) {
              if (snapshot.data != null)
                val = snapshot.data.currentPosition.inSeconds /
                    snapshot.data.duration.inSeconds;
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: LinearProgressIndicator(
                value: val,
              ),
            );
          }
        },
      );
    } else {
      widget = SizedBox();
    }

    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: IconButton(
            icon: Icon(model.isPlayingSync ? Icons.stop : Icons.play_arrow),
            onPressed: () {
              if (model.isPlayingSync) {
                model.stopPlaying();
              } else {
                model.currentUrl = url;
              }
            },
          ),
        ),
        Flexible(flex: 10, child: widget),
        Flexible(flex: 1, child: SizedBox())
      ],
    );
  }
}

class AyahWidget extends StatelessWidget {
  final Ayahs aya;
  const AyahWidget({Key key, this.aya}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Center(
      child: Card(
        color: AppColors.mainColor,
        child: Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.all(8),
          width: media.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: media.width * 0.7,
                child: Text(
                  "${aya.text}",
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text("(${aya.numberInSurah})")
            ],
          ),
        ),
      ),
    );
  }
}

class SuraWidget extends StatelessWidget {
  final Surahs sura;
  const SuraWidget({Key key, this.sura}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Center(
      child: Card(
        color: AppColors.mainColor,
        child: Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.all(8),
          width: media.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("عدد الآيات ${sura.ayahs.length}"),
              Text(
                "${sura.name}",
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
