import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/quran/QuranNewVM.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class QuranNewScreen extends StatelessWidget {
  const QuranNewScreen({Key key}) : super(key: key);
  static const route = "QuranNewScreen";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuranNewVM>.reactive(
      builder: (ctx, model, ch) {
        if (model.isBusy) return LoadingWidget();
        return Flex(
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
                itemCount: model.pagesNumber.length,
                onPageChanged: (page) {
                  model.currentPageNumber = page;
                },
                itemBuilder: (BuildContext context, int index) {
                  int newIndex = model.pagesNumber[index] + 3;
                  String dex = "";
                  if (newIndex.toString().length == 1) dex = "000$newIndex";
                  if (newIndex.toString().length == 2) dex = "00$newIndex";
                  if (newIndex.toString().length == 3) dex = "0$newIndex";
                  if (newIndex.toString().length == 4) dex = "$newIndex";
                  return ExtendedImage.asset(
                    "assets/L/$dex.png",
                    fit: BoxFit.cover,
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
                  );
                },
              ),
            ),
          ],
        );
      },
      viewModelBuilder: () => Get.find<QuranNewVM>(),
      fireOnModelReadyOnce: true,
      onModelReady: (vv) => vv.initData(),
      disposeViewModel: false,
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
          txt: model.selectedSurah.name,
          img: "dd.png",
          isMiddle: false,
          onTap: () {
            Get.bottomSheet(
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Container(
                  color: AppColors.adanNormal,
                  child: ListView(
                    children: <Widget>[
                      ...model.suras.map(
                        (e) => InkWell(
                          onTap: () {
                            model.selectedSurah = e;
                            model.saveSura();
                            Get.back();
                          },
                          child: SuraWidget(
                            name: e.name,
                            info: e.ayahs.length.toString(),
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
          txt: "الصفحة ${model.currentPageNumber}",
          img: "dd.png",
          isMiddle: true,
          onTap: () {
            Get.bottomSheet(
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Container(
                  color: AppColors.adanNormal,
                  child: ListView(
                    children: <Widget>[
                      ...model.pagesNumber.map(
                        (e) => InkWell(
                          onTap: () {
                            model.ctrl.animateToPage(model.indexOfPage(e),
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInCirc);

                            Get.back();
                          },
                          child: SuraWidget(
                            name: "الصفحة $e",
                            info: model.selectedSurah.ayahs
                                .where((g) => g.page == e)
                                .length
                                .toString(),
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

  _getTab(
      {String txt,
      String img,
      Function onTap,
      bool isMiddle = false,
      isbookMarked = false}) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                txt,
                style: AppThemes.quranBarTextStyle,
              ),
              Image.asset(
                "assets/icons/$img",
                fit: BoxFit.cover,
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
              Text("عدد الآيات $info"),
              Text(
                "$name",
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
