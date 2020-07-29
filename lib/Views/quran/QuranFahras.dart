import 'package:awrad/Views/quran/QuranNewVM.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/widgets/AlarmOption/AlarmOptions.dart';
import 'package:awrad/widgets/AlarmOption/ExpansionVM.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyErrorWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class QuranFahras extends StatelessWidget {
  const QuranFahras({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuranNewVM>.reactive(
      disposeViewModel: false,
      builder: (ctx, model, child) {
        if (model.isBusy) return LoadingWidget();
        if (model.hasError) return MyErrorWidget(err: model.modelError);
        return Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("اسم السورة"),
                  Text("عددآياتها"),
                  Text("رقم الصفحة")
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 15,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: model.suras.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sura = model.suras[index];
                    return Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            sura.name,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            sura.ayahs.length.toString(),
                            textAlign: TextAlign.center,
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

                      // ViewModelBuilder<ExpansionVM>.reactive(
                      //   viewModelBuilder: () => ExpansionVM(
                      //     isAwrad: false,
                      //     wrd: WrdModel(
                      //         uid: sura.englishName,
                      //         wrdDesc: "",
                      //         wrdName: sura.name,
                      //         wrdType: ""),
                      //   ),
                      //   builder: (ctx, model, ch) => AlarmOptions(
                      //     wrd: model.wrd,
                      //   ),
                      // )
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
