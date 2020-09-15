import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/quran/QuranNewVM.dart';
import 'package:awrad/models/QuranModel.dart';
import 'package:awrad/widgets/AudioPlayer/MyAudioPlayer.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyErrorWidget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class QuranNewScreen extends StatefulWidget {
  final String suraName;
  final int juzNumber;
  const QuranNewScreen({Key key, this.suraName = "", this.juzNumber = -1})
      : super(key: key);
  static const route = "QuranNewScreen";

  @override
  _QuranNewScreenState createState() => _QuranNewScreenState();
}

class _QuranNewScreenState extends State<QuranNewScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuranNewVM>.reactive(
      builder: (ctx, model, ch) {
        if (model.isBusy) return LoadingWidget();
        if (model.hasError) return MyErrorWidget(err: model.modelError);
        return Stack(
          children: <Widget>[
            Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    color: AppColors.mainColorSelected,
                    child: QuranBar(),
                  ),
                ),
                Flexible(
                  flex: 20,
                  fit: FlexFit.tight,
                  child: PageView.builder(
                    controller: model.ctrl,
                    itemCount: model.quran.data.pagesLength,
                    onPageChanged: (index) {
                      model.currentPageNumber = index;
                      log(model.selectedSurah.name);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      int newIndex = model.quran.data.quranPages[index] + 3;
                      String dex = "";
                      if (newIndex.toString().length == 1) dex = "000$newIndex";
                      if (newIndex.toString().length == 2) dex = "00$newIndex";
                      if (newIndex.toString().length == 3) dex = "0$newIndex";
                      if (newIndex.toString().length == 4) dex = "$newIndex";
                      return LayoutBuilder(
                        builder: (context, constraints) => ExtendedImage.asset(
                          "assets/L/$dex.png",
                          fit: BoxFit.fill,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          mode: ExtendedImageMode.gesture,
                          initGestureConfigHandler: (state) {
                            return GestureConfig(
                              minScale: 1,
                              animationMinScale: 0.9,
                              maxScale: 2.0,
                              animationMaxScale: 2.1,
                              speed: 1.0,
                              inertialSpeed: 100.0,
                              initialScale: 1.0,
                              inPageView: true,
                              initialAlignment: InitialAlignment.center,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 5,
              left: -5,
              child: Container(
                height: 40,
                child: model.player.builderIsPlaying(
                  builder: (context, isPlayin) => FloatingActionButton(
                    onPressed: () async {
                      Get.bottomSheet(
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: MyAudioPlayer(
                            pageNumber: model.currentPageNumber,
                            player: model.player,
                          ),
                        ),
                        isDismissible: true,
                        enableDrag: true,
                      );
                    },
                    child: Icon(
                      isPlayin ? Icons.pause : Icons.play_arrow,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      viewModelBuilder: () => QuranNewVM(),
      onModelReady: (vv) =>
          vv.initData(suraName: widget.suraName, juzNumber: widget.juzNumber),
      disposeViewModel: true,
    );
  }
}

class QuranBar extends ViewModelWidget<QuranNewVM> {
  const QuranBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuranNewVM model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _getTab(
          txt: "رجوع",
          img: "close.png",
          isClose: true,
          isMiddle: false,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        _getTab(
          txt: "الصفحة",
          img: "dd.png",
          pageNumber: model.currentPageNumber,
          isMiddle: true,
          onTap: () {
            Get.bottomSheet(
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Container(
                  color: AppColors.adanNormal,
                  child: model.isJuz
                      ? ListView(
                          children: <Widget>[
                            ..._getJuzData(model, model.currentJuzNumber,
                                isCurrent: true),
                            ..._getJuzData(model, model.nextJuz,
                                isCurrent: true),
                            ..._getJuzData(model, model.extraNexJuz,
                                isCurrent: true),
                          ],
                        )
                      : ListView(
                          children: <Widget>[
                            ..._getData(model, model.selectedSurah,
                                isCurrent: true),
                            ..._getData(model, model.nextSurah,
                                isCurrent: false),
                            ..._getData(model, model.extraNextSurah),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
        _getTab(
            txt: "احفظ علامة",
            img: "bookmark.png",
            isMiddle: false,
            isbookMarked: model.isBookMarked,
            onTap: () {
              model.saveBookMark();
            }),
      ],
    );
  }

  List<Widget> _getData(QuranNewVM model, Surahs sura,
      {bool isCurrent = true}) {
    // final text = isCurrent ? "السورة الحالية " : "السورة التالية ";
    if (sura != null) {
      return [
        Text(
          "${sura.name}",
          style: AppThemes.miniFahrasTextStyle,
          textAlign: TextAlign.center,
        ),
        ...sura.listOfPages.map(
          (e) => InkWell(
            onTap: () {
              model.ctrl.animateToPage(model.indexOfPage(e),
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInCirc);

              Get.back();
            },
            child: SuraWidget(
              name: "الصفحة $e",
              info: sura.ayahs.where((g) => g.page == e).length.toString(),
            ),
          ),
        ),
      ];
    }

    return [SizedBox.shrink()];
  }

  List<Widget> _getJuzData(QuranNewVM model, int juzNumber,
      {bool isCurrent = true}) {
    // final text = isCurrent ? "السورة الحالية " : "السورة التالية ";
    return [
      Text(
        "الجزء $juzNumber",
        style: AppThemes.miniFahrasTextStyle,
        textAlign: TextAlign.center,
      ),
      ...model.getJuzPages(juzNumber).map(
            (e) => InkWell(
              onTap: () {
                model.ctrl.animateToPage(model.indexOfPage(e),
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInCirc);

                Get.back();
              },
              child: SuraWidget(
                name: "الصفحة $e",
                info: model.juzAyas(juzNumber).length.toString(),
              ),
            ),
          ),
    ];
  }

  _getTab(
      {String txt,
      String img,
      Function onTap,
      bool isMiddle = false,
      isbookMarked = false,
      isClose = false,
      int pageNumber = -1}) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              !isClose
                  ? SizedBox()
                  : Image.asset(
                      "assets/icons/$img",
                      fit: BoxFit.cover,
                      width: 20,
                      color: isbookMarked ? AppColors.mainColor : Colors.white,
                    ),
              pageNumber > -1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("$txt  "),
                        Text(
                          pageNumber.toString(),
                          style: AppThemes.timeTimerTextStyle
                              .copyWith(color: Colors.black),
                        )
                      ],
                    )
                  : Text(txt),
              isClose
                  ? SizedBox()
                  : Image.asset(
                      "assets/icons/$img",
                      fit: BoxFit.cover,
                      width: 20,
                      color: isbookMarked ? AppColors.mainColor : Colors.white,
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

class SuraWidget extends StatelessWidget {
  final String name;
  final String info;
  const SuraWidget({Key key, this.name, this.info}) : super(key: key);

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
              Text(
                "عدد الآيات $info",
                style:
                    AppThemes.timeTimerTextStyle.copyWith(color: Colors.black),
              ),
              Text(
                "$name",
                overflow: TextOverflow.ellipsis,
                style:
                    AppThemes.timeTimerTextStyle.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
