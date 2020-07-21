import 'package:awrad/Views/quran/QuranScreen.dart';
import 'package:awrad/Views/services/MyServices.dart';
import 'package:awrad/Views/welcome/WelcomeView.dart';

import 'package:awrad/widgets/BkScaffold.dart';
import 'package:awrad/widgets/MyBtn.dart';
import 'package:flutter/material.dart';

import 'awrad/AwradTypesScreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bucket = PageStorageBucket();
  List<Widget> pages = [
    WelcomeScreed(key: PageStorageKey('WelcomeScreed')),
    QuranScreen(key: PageStorageKey('QuranScreen')),
    AwradTypesScreen(key: PageStorageKey('AwradTypesScreen')),
    MyServices(key: PageStorageKey('welcome3')),
  ];
  List<GlobalKey> _keys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  int index = 0;
  String route = "services";
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
                      final k = (_keys[index] as GlobalKey<NavigatorState>);
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
        final k = (_keys[index] as GlobalKey<NavigatorState>);
        if (k.currentState.canPop())
          k.currentState.pop();
        else
          return Future.value(true);
      },
      child: Navigator(
        onGenerateRoute: (sett) =>
            MaterialPageRoute(builder: (_) => pages[index], settings: sett),
        key: _keys[index],
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
  int currentIndex = 0;
  String currentKey = "main";

  @override
  Widget build(BuildContext context) {
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
                  txt: "غير",
                  icon: "other",
                  isSelected: currentIndex == 4,
                  index: 4,
                  selectedWidth: activeWidth,
                  width: iconWidth,
                  onPressed: _setState),
              MyBtn(
                  txt: "خدمات",
                  icon: "services",
                  selectedWidth: activeWidth,
                  isSelected: currentIndex == 3,
                  index: 3,
                  width: iconWidth,
                  onPressed: _setState),
              MyBtn(
                  txt: "الأوراد",
                  selectedWidth: activeWidth,
                  icon: "awrad",
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
