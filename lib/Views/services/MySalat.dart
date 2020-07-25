import 'package:adhan/adhan.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/services/AdanVM.dart';
import 'package:awrad/Views/services/TimerVm.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../../Consts/ConstMethodes.dart';
import 'MyQubla.dart';

class MySalat extends StatelessWidget {
  MySalat({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdanVm>.reactive(
        builder: (context, model, ch) => model.isBusy
            ? LoadingWidget()
            : model.hasPermission
                ? Prayers()
                : LocationErrorWidget(
                    error: "يرجى تزويد التطبيق بالاذونات المطلوبة للمتابعة",
                    callback: model.askForPermissions(),
                  ),
        onModelReady: (vmm) => vmm.askForPermissions(),
        disposeViewModel: false,
        viewModelBuilder: () => AdanVm());
  }
}

class Prayers extends ViewModelWidget<AdanVm> {
  const Prayers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, AdanVm vm) {
    // TODO: implement build
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ViewModelBuilder<TimerVm>.reactive(
            builder: (context, timer, ch) => Container(
              child: Text(
                timer.time,
                style: AppThemes.timerTextStyle,
              ),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.adanNormal,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            viewModelBuilder: () => TimerVm(),
          ),
          Text("Choose Sound for adan"),
          FutureBuilder(
            future: vm.adanTimes,
            builder:
                (BuildContext context, AsyncSnapshot<PrayerTimes> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return LoadingWidget();

              if (snapshot.hasError) return ErrorWidget(snapshot.error);
              final data = snapshot.data;
              return Column(
                children: <Widget>[..._timeRow(data)],
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> _timeRow(PrayerTimes pr) {
    final nxtPrayer = pr.nextPrayer();
    return azanTimes.map((e) {
      final isActive = nxtPrayer == e.type;
      return e.type == Prayer.none
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(flex: 1, child: SizedBox()),
                  _container(e.name, isActive: isActive),
                  Expanded(flex: 1, child: SizedBox()),
                  _container(pr.timeForPrayer(e.type).myTimeNoSeconds,
                      isTime: true, isActive: isActive),
                  Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            );
    }).toList();
  }

  Widget _container(String text, {isActive = false, isTime = false}) {
    return Expanded(
      flex: 8,
      child: Container(
        height: 60,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.adanActive : AppColors.adanNormal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AutoSizeText(
                text,
                maxLines: 1,
                style: AppThemes.azanTimeTextStyle,
                textAlign: TextAlign.center,
              ),
              isTime
                  ? Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.adanNotificationCircle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/bell.svg",
                      ))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
