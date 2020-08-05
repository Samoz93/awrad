import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/quran/QuranNewScreen.dart';
import 'package:awrad/Views/quran/QuranNewVM.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/widgets/AlarmOption/ExpansionVM.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyErrorWidget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class QuranFahras extends StatelessWidget {
  const QuranFahras({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuranNewVM>.reactive(
      disposeViewModel: false,
      builder: (ctx, mainModel, child) {
        if (mainModel.isBusy) return LoadingWidget();
        if (mainModel.hasError) return MyErrorWidget(err: mainModel.modelError);
        return Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(
                color: AppColors.mainColorSelected,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "اسم السورة",
                      style: AppThemes.quranFahrasTitleTextStyle,
                    ),
                    Text(
                      "عدد آياتها",
                      style: AppThemes.quranFahrasTitleTextStyle,
                    ),
                    Text(
                      "رقم الصفحة",
                      style: AppThemes.quranFahrasTitleTextStyle,
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 15,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: mainModel.suras.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sura = mainModel.suras[index];
                    return ViewModelBuilder<ExpansionVM>.reactive(
                      viewModelBuilder: () => ExpansionVM(
                        isAwrad: false,
                        wrd: WrdModel(
                            uid: sura.englishName,
                            wrdDesc: "",
                            wrdName: sura.name,
                            wrdType: sura.revelationType),
                      ),
                      builder: (ctx, model, ch) => InkWell(
                        onTap: () {
                          mainModel.selectedSurah = sura;
                          mainModel.saveSura();

                          Navigator.of(ctx).push(MaterialPageRoute(
                            builder: (context) => QuranNewScreen(),
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: mainModel.lastSavedSuraIndex == index
                                ? AppColors.adanActive
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(model.showAlaramOption
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down),
                                          onPressed: () {
                                            model.toggelAlarmOption();
                                          },
                                        ),
                                        Text(
                                          sura.name,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          Center(
                                            child: ExtendedImage.asset(
                                              "assets/decoration/main.png",
                                              fit: BoxFit.contain,
                                              width: 60,
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: Center(
                                              child: Text(
                                                sura.ayahs.length.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      sura.ayahs[0].page.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: model.showAlaramOption ? 150 : 0,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: <Widget>[
                                        ToggleButtons(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          children: <Widget>[
                                            ...daysOfWeek2.map(
                                              (e) => Text(e.name),
                                            ),
                                          ],
                                          isSelected: model.selectionBool,
                                          onPressed: (index) {
                                            model.addDay(index);
                                          },
                                          color: Colors.red,
                                        ),
                                        ToggleButtons(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          children: <Widget>[
                                            ...timesOfDay.map(
                                              (e) => Text(e.toString()),
                                            ),
                                          ],
                                          isSelected: model.selectionBoolTimes,
                                          onPressed: (index) {
                                            model.addTime(index);
                                          },
                                          color: Colors.red,
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(
                                                  Icons.alarm_add,
                                                  color: AppColors.addColor,
                                                ),
                                                onPressed: () {
                                                  model.saveDate();
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.alarm_off,
                                                    color: !model.hasReminder
                                                        ? Colors.grey
                                                        : AppColors
                                                            .deleteColor),
                                                onPressed: !model.hasReminder
                                                    ? null
                                                    : model.deleteThisReminder,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
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
              ),
            ),
          ],
        );
      },
      viewModelBuilder: () => Get.find<QuranNewVM>(),
      onModelReady: (vn) => vn.initData(),
    );
  }
}
