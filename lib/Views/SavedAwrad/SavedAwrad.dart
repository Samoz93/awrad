import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/SavedAwrad/SavedAwradVM.dart';
import 'package:awrad/widgets/ReminderWidget/ReminderWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

class SavedAwrad extends StatelessWidget {
  SavedAwrad({Key key}) : super(key: key);
  static const route = "SavedAwrad";
  // final vm = SavedAwradVM();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return ViewModelBuilder<SavedAwradVM>.reactive(
      // disposeViewModel: false,
      builder: (ctx, model, ch) => Container(
        height: media.height,
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  // color: Colors.red,
                  child: LayoutBuilder(
                    builder: (context, box) => Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _getText(
                                  "اوراد يوم  ${model.todayName()}", 0, model),
                              _getText("جميع الأوراد", 1, model)
                            ],
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInSine,
                          bottom: 0,
                          right: model.selectedTap * box.maxWidth * 0.5,
                          child: Container(
                            color: Colors.black,
                            width: box.maxWidth * 0.5,
                            height: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 15,
              fit: FlexFit.tight,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                  ),
                  ...getAwradData(model),
                ],
              ),
            ),
          ],
        ),
      ),

      viewModelBuilder: () => SavedAwradVM(),
    );
  }

  List<Widget> getAwradData(SavedAwradVM model) {
    final List<Widget> lst = [];
    if (model.awradData.isEmpty && model.quranData.isEmpty)
      lst.add(
        SliverFillRemaining(
          child: Center(
            child: Text("لا يوجد أوراد محفوظة "),
          ),
        ),
      );

    if (model.awradData.isNotEmpty) {
      lst.add(SliverPersistentHeader(
          delegate: MyHeader(text: "الأوراد", maxEx: 60, min: 20)));
      lst.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                height: 100,
                child: ReminderWidget(
                  uid: model.awradData[index].id,
                  deleteFunction: () {
                    model.deleteNotification(model.awradData[index].id,
                        showNotification: true);
                  },
                ),
              );
            },
            childCount: model.awradData.length,
          ),
        ),
      );
    }

    if (model.quranData.isNotEmpty) {
      lst.add(
        SliverPersistentHeader(
          delegate: MyHeader(text: "أوراد القرآن", maxEx: 60, min: 20),
        ),
      );
      lst.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final id = model.quranData[index].id;
              return Container(
                height: 100,
                child: ReminderWidget(
                  uid: id,
                  deleteFunction: () {
                    model.deleteNotification(model.quranData[index].id,
                        showNotification: true);
                  },
                ),
              );
            },
            childCount: model.quranData.length,
          ),
        ),
      );
    }

    return lst;
  }

  Widget _getText(String txt, int tapNumber, SavedAwradVM vm) {
    return Flexible(
      child: InkWell(
        onTap: () {
          vm.selectedTap = tapNumber;
        },
        child: Center(
          child: Text(
            txt,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class MyHeader implements SliverPersistentHeaderDelegate {
  double maxEx;
  double min;
  String text;
  MyHeader({this.maxEx, this.min, this.text});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // transform: Matrix4.rotationZ(_rotate(shrinkOffset)),
      // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(_rotate(shrinkOffset) * 50),
        color: AppColors.mainColorSelected,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: (min - shrinkOffset), color: Colors.white),
        ),
      ),
    );
  }

  // _opacity(double offset) {
  //   return 1 - max(0, offset) / maxEx;
  // }

  // _rotate(double offset) {
  //   return 1 - (max(1, offset) / maxEx);
  // }

  @override
  double get maxExtent => maxEx;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}
