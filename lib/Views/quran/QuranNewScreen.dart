import 'package:awrad/Views/quran/QuranNewVM.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuranNewScreen extends StatelessWidget {
  const QuranNewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = 20.0;
    // final toAvoid = size + 10;
    return ViewModelBuilder<QuranNewVM>.reactive(
      builder: (ctx, model, ch) {
        if (model.isBusy) return LoadingWidget();
        return PageView.builder(
          itemCount: model.pages.length,
          itemBuilder: (BuildContext context, int index) {
            return LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(constraints.maxHeight * 0.08),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          index == 0
                              ? Text(
                                  "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                                  style: TextStyle(
                                    fontSize: constraints.maxHeight * 0.03,
                                    fontFamily: "madina",
                                  ),
                                )
                              : SizedBox(),
                          Text(
                            model.pages[index].text.fold(
                                "",
                                (previousValue, e) =>
                                    "$previousValue ${e.normalizeText} ﴿${e.numberInSurah}﴾ "),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "madina",
                              fontSize: constraints.maxHeight * 0.026,
                            ),
                          ),
                          // Text(
                          //   model.pages[index].text,
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       fontSize: constraints.maxHeight * 0.026),
                          // ),
                          Text(model.pages[index].pageNumer.toString())
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/decoration/all.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ],
              ),
            );
          },
        );
      },
      viewModelBuilder: () => QuranNewVM(),
      fireOnModelReadyOnce: true,
      onModelReady: (vv) => vv.initData(),
      disposeViewModel: false,
    );
  }
}
