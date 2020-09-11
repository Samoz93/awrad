import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/welcome/FirstPage.dart';

import 'package:awrad/Views/welcome/SlidesViewMode.dart';
import 'package:awrad/models/SlideModel.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

class WelcomeScreed extends StatelessWidget {
  WelcomeScreed({Key key}) : super(key: key);
  // final noneActiveSize = 10.0;
  // final activeSize = 20.0;
  final _ctrl = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ViewModelBuilder<SlideViewModel>.reactive(
        builder: (context, model, ch) {
          if (model.hasError) return Text("model.modelError.toString()");
          return model.isBusy
              ? Center(
                  child: LoadingWidget(),
                )
              : Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Flexible(
                      flex: 15,
                      child: PageView.builder(
                        controller: _ctrl,
                        itemCount: model.data.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == model.data.length) return FirstPage();
                          return SlideView(
                            model: model.data[index],
                          );
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _ctrl,
                          count: model.data.length + 1,
                          effect: WormEffect(
                              dotColor: AppColors.mainColor,
                              activeDotColor: AppColors.mainColorSelected),
                        ),
                      ),
                    ),
                  ],
                );
        },
        viewModelBuilder: () => SlideViewModel(),
      ),
    );
  }
}

class SlideView extends StatelessWidget {
  final SlideModel model;
  const SlideView({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Container(
      height: media.height,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            flex: 13,
            child: Stack(
              children: <Widget>[
                ExtendedImage.network(
                  model.img,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: LayoutBuilder(
                    builder: (context, constraints) => Container(
                      height: constraints.maxHeight * 0.3,
                      width: constraints.maxWidth,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            model.name,
                            style: AppThemes.titleTextStyle,
                          ),
                        ),
                      ),
                      decoration:
                          BoxDecoration(gradient: AppThemes.linearTitle),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                model.desc,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
