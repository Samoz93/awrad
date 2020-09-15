import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/quran/JuzFahras.dart';
import 'package:awrad/Views/quran/QuranNewVM.dart';
import 'package:awrad/Views/quran/SuarFahras.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyErrorWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class QuranFahras extends StatelessWidget {
  const QuranFahras({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return ViewModelBuilder<QuranNewVM>.reactive(
      createNewModelOnInsert: true,
      disposeViewModel: false,
      builder: (ctx, mainModel, child) {
        if (mainModel.isBusy) return LoadingWidget();
        if (mainModel.hasError) return MyErrorWidget(err: mainModel.modelError);
        return Stack(
          children: <Widget>[
            Container(
                height: media.height,
                child: Flex(
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
                              mainModel.isJuzFahras
                                  ? "رقم الجزء"
                                  : "اسم السورة",
                              style: AppThemes.quranFahrasTitleTextStyle,
                            ),
                            Text(
                              "عدد الآيات",
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
                        child:
                            mainModel.isJuzFahras ? JuzFahras() : SuarFahras(),
                      ),
                    ),
                  ],
                )),
            Positioned(
              left: media.width * 0.01,
              bottom: media.height * 0.01,
              child: FloatingActionButton.extended(
                label: Text(mainModel.fahrasString),
                onPressed: () {
                  mainModel.isJuzFahras = false;
                },
              ),
            )
          ],
        );
      },
      viewModelBuilder: () => Get.find<QuranNewVM>(),
      onModelReady: (vn) => vn.initData(),
    );
  }
}
