import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/quran/QuranNewVM.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/widgets/AlarmOption/ExpansionVM.dart';
import 'package:awrad/widgets/Schedular2/Schedular2.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'QuranNewScreen.dart';

class SuarFahras extends ViewModelWidget<QuranNewVM> {
  const SuarFahras({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuranNewVM mModel) {
    final media = MediaQuery.of(context).size;
    return ListView.builder(
      addAutomaticKeepAlives: false,
      physics: BouncingScrollPhysics(),
      itemCount: mModel.suras.length,
      itemBuilder: (BuildContext context, int index) {
        final sura = mModel.suras[index];
        return ViewModelBuilder<ExpansionVM>.reactive(
          createNewModelOnInsert: true,
          onModelReady: (v) => v.init(
            isAwrad: false,
            isJuz: false,
            juzPage: -1,
          ),
          disposeViewModel: true,
          fireOnModelReadyOnce: false,
          initialiseSpecialViewModelsOnce: false,
          viewModelBuilder: () => ExpansionVM(
            wrd: WrdModel(
              uid: sura.englishName,
              wrdDesc: "",
              wrdName: sura.name,
              wrdType: sura.revelationType,
            ),
          ),
          builder: (ctx, model, ch) => InkWell(
            onTap: () {
              if (!mModel.isJuzFahras) {
                mModel.selectedSurah = sura;
                mModel.saveSura();
              }

              Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (context) => QuranNewScreen(
                    suraName: sura.name,
                    juzNumber: -1,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: !mModel.isJuzFahras && mModel.lastSavedSuraIndex == index
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
                        child: LayoutBuilder(
                          builder: (context, constraints) => Row(
                            children: <Widget>[
                              Container(
                                width: constraints.maxWidth * 0.3,
                                child: IconButton(
                                  icon: Icon(model.showAlaramOption
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down),
                                  onPressed: () {
                                    model.toggelAlarmOption();
                                  },
                                ),
                              ),
                              Container(
                                width: constraints.maxWidth * 0.7,
                                child: Text(
                                  sura.name,
                                  style:
                                      TextStyle(fontSize: media.width * 0.045),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
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
                                    "${sura.ayahs.length}",
                                    textAlign: TextAlign.center,
                                    style: AppThemes.azanTimeStyle,
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
                          "${sura.ayahs[0].page}",
                          textAlign: TextAlign.center,
                          style: AppThemes.azanTimeStyle,
                        ),
                      )
                    ],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: model.showAlaramOption ? 180 : 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ...daysOfWeek2.map(
                                    (e) => Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: InkWell(
                                        onTap: () {
                                          model.selectedDay = e.dateWeek;
                                        },
                                        child: CheckButton(
                                          isSelected:
                                              model.selectedDay == e.dateWeek,
                                          text: e.name,
                                          perc: model.getPercentage(e.dateWeek),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ...azanTimes.map(
                                    (e) => Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: InkWell(
                                        onTap: () {
                                          model.addTimes(e.type);
                                        },
                                        child: CheckButton(
                                          isSelected:
                                              model.isTimeSelected(e.type),
                                          text: e.name,
                                          hasPerc: false,
                                          perc: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: AppColors.addColor,
                                      ),
                                      onPressed: () {
                                        model.saveDate();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: AppColors.deleteColor,
                                      ),
                                      onPressed: () {
                                        model.toggelAlarmOption();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: !model.hasReminder
                                              ? Colors.grey
                                              : AppColors.deleteColor),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
