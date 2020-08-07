import 'dart:developer';

import 'package:awrad/Views/SavedAwrad/SavedAwrad.dart';
import 'package:awrad/Views/quran/QuranMainScreen.dart';
import 'package:awrad/Views/services/MySalat.dart';
import 'package:awrad/Views/services/MyServices.dart';
import 'package:awrad/Views/welcome/WelcomeView.dart';
import 'package:awrad/base/locator.dart';

import 'package:awrad/widgets/BkScaffold.dart';
import 'package:awrad/widgets/MyBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'awrad/AwradTypesScreen.dart';

class MainPageClass {
  Widget widget;
  GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

  MainPageClass({this.widget});
}

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bucket = PageStorageBucket();
  List<MainPageClass> pages = [
    MainPageClass(widget: WelcomeScreed(key: PageStorageKey('WelcomeScreed'))),
    MainPageClass(
        widget: QuranMainScreen(key: PageStorageKey('QuranMainScreen'))),
    MainPageClass(widget: SavedAwrad(key: PageStorageKey('SavedAwrad'))),
    MainPageClass(
        widget: AwradTypesScreen(key: PageStorageKey('AwradTypesScreen'))),
    MainPageClass(
        widget: MyServices(
      key: PageStorageKey('MyServices'),
    )),
  ];
  int index = 0;
  String route = "services";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      selectedData.listen((value) {
        log("messageAndroid$value");
        if (value == "azan") return _goToSalat();
        if (value.contains("awrad")) {
          setState(() {
            index = 2;
          });
        }
      });
      iosData.listen(
        (value) {
          if (value.payload == "azan") return _goToSalat();
          if (value.payload.contains("awrad")) {
            setState(() {
              index = 2;
            });
          }
        },
      );
    });
  }

  _goToSalat() {
    // pages[4].widget = MyServices(
    //   key: PageStorageKey('MyServices'),
    //   goToSalat: true,
    // );
    setState(() {
      index = 4;
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      pages[4].globalKey.currentState.push(
            MaterialPageRoute(
              builder: (context) => MySalat(),
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BkScaffold(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomAppBar(
            child: MyBottomAppBar(
              selectedIndex: index,
              onRouteChanged: (rou, ind) {
                setState(
                  () {
                    if (index == ind) {
                      final k = pages[index].globalKey;
                      k.currentState.popUntil((route) => route.isFirst);
                    } else {
                      index = ind;
                      route = rou;
                    }
                  },
                );
              },
            ),
          ),
          body: PageStorage(
            bucket: bucket,
            child: _buildPage(index),
          )),
    );
  }

  _buildPage(int index) {
    return WillPopScope(
      onWillPop: () {
        final k = pages[index].globalKey;
        if (k.currentState.canPop())
          k.currentState.pop();
        else
          return Future.value(true);
      },
      child: Navigator(
        onGenerateRoute: (sett) => MaterialPageRoute(
            builder: (_) => pages[index].widget, settings: sett),
        key: pages[index].globalKey,
      ),
    );
  }
}

class MyBottomAppBar extends StatefulWidget {
  final Function(String, int) onRouteChanged;
  final int selectedIndex;
  MyBottomAppBar({Key key, this.onRouteChanged, this.selectedIndex})
      : super(key: key);

  @override
  _MyBottomAppBarState createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  String currentKey = "main";
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    currentIndex = widget.selectedIndex;

    final media = MediaQuery.of(context).size;
    final activeWidth = media.width * 0.3;
    final iconWidth = (media.width - activeWidth) / 4;
    return Container(
      height: 50,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MyBtn(
                  txt: "خدمات",
                  icon: "services",
                  isSelected: currentIndex == 4,
                  index: 4,
                  selectedWidth: activeWidth,
                  width: iconWidth,
                  onPressed: _setState),
              MyBtn(
                  txt: "الاوراد",
                  icon: "awrad",
                  selectedWidth: activeWidth,
                  isSelected: currentIndex == 3,
                  index: 3,
                  width: iconWidth,
                  onPressed: _setState),
              MyBtn(
                  txt: "جدول الأوراد",
                  selectedWidth: activeWidth,
                  icon: "saved",
                  isSelected: currentIndex == 2,
                  index: 2,
                  width: iconWidth,
                  onPressed: _setState),
              MyBtn(
                  txt: "القرآن",
                  selectedWidth: activeWidth,
                  icon: "quran",
                  isSelected: currentIndex == 1,
                  index: 1,
                  width: iconWidth,
                  onPressed: _setState),
              MyBtn(
                  txt: "الرئيسية",
                  selectedWidth: activeWidth,
                  icon: "home",
                  isSelected: currentIndex == 0,
                  width: iconWidth,
                  index: 0,
                  onPressed: _setState),
            ],
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInCubic,
            bottom: 0,
            left: currentIndex * iconWidth,
            child: Container(
              alignment: Alignment.bottomCenter,
              color: Colors.white,
              width: activeWidth,
              height: 5,
            ),
          ),
        ],
      ),
    );
  }
  // _getLeft(){
  //   if(currentIndex > 0){

  //   }else{
  //     return currentIndex * active
  //   }
  // }
  _setState(String v, int index) {
    currentIndex = index;

    setState(() {
      currentKey = v;
    });
    widget.onRouteChanged(v, index);
  }
}
