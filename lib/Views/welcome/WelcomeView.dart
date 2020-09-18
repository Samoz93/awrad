import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/welcome/FirstPage.dart';

import 'package:awrad/Views/welcome/SlidesViewMode.dart';
import 'package:awrad/models/SlideModel.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
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
      child: Stack(
        children: <Widget>[
          ViewModelBuilder<SlideViewModel>.reactive(
            builder: (context, model, ch) {
              if (model.hasError) return Text("model.modelError.toString()");
              return model.isBusy
                  ? Center(
                      child: LoadingWidget(),
                    )
                  : Stack(
                      children: <Widget>[
                        PageView.builder(
                          controller: _ctrl,
                          itemCount: model.data.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == model.data.length) return FirstPage();
                            return ExtendedImage.network(
                              model.data[index].img,
                              height: double.infinity,
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
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
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.share),
              iconSize: 40,
              color: AppColors.mainColor,
              onPressed: () {
                Share.share(shareLink,
                    subject: "حمل تطبيق أذكار الصالحين مجاناً الآن");
              },
            ),
          )
        ],
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
      child: Stack(
        children: <Widget>[
          ExtendedImage.network(
            model.img,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: LayoutBuilder(
          //     builder: (context, constraints) => Container(
          //       height: constraints.maxHeight * 0.3,
          //       width: constraints.maxWidth,
          //       child: Align(
          //         alignment: Alignment.bottomCenter,
          //         child: Padding(
          //           padding: const EdgeInsets.all(20.0),
          //           child: Text(
          //             model.name,
          //             style: AppThemes.titleTextStyle,
          //           ),
          //         ),
          //       ),
          //       decoration: BoxDecoration(gradient: AppThemes.linearTitle),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
