import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/services/AdanVM.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyScf.dart';
import 'package:awrad/widgets/TimerWidget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'AdanPermissionVm.dart';
import 'MyQubla.dart';

class MySalat extends StatelessWidget {
  MySalat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "أوقات الصلاة",
      child: ViewModelBuilder<AdanPermissionVm>.reactive(
        builder: (ctx, perModel, ch) {
          if (perModel.isBusy) return LoadingWidget();
          if (perModel.hasPermission) {
            return ViewModelBuilder<AdanVm>.reactive(
              builder: (context, model, ch) =>
                  model.isBusy ? LoadingWidget() : PrayersWidget(),
              onModelReady: (vmm) => vmm.initData(),
              disposeViewModel: false,
              viewModelBuilder: () => AdanVm(),
            );
          } else {
            return LocationErrorWidget(
              error: "يرجى تزويد التطبيق بالاذونات المطلوبة للمتابعة",
              callback: () => perModel.initData(),
            );
          }
        },
        viewModelBuilder: () => AdanPermissionVm(),
        onModelReady: (vv) => vv.initData(),
        fireOnModelReadyOnce: true,
        disposeViewModel: false,
      ),
    );
  }
}

class PrayersWidget extends ViewModelWidget<AdanVm> {
  const PrayersWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, AdanVm viewModel) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Flexible(flex: 3, child: DayWidget()),
        Flexible(flex: 15, child: AdanTimesWidget()),
      ],
    );
  }
}

class DayWidget extends ViewModelWidget<AdanVm> {
  const DayWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, AdanVm viewModel) {
    final media = MediaQuery.of(context).size;
    final iconSize = 40.0;
    return Container(
      color: AppColors.mainColorSelected,
      width: media.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          viewModel.canSetNext
              ? IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    viewModel.nextDate();
                  },
                )
              : SizedBox(
                  width: iconSize,
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(viewModel.selectedDate, style: AppThemes.todayTimeTextStyle),
              Text("${viewModel.adanData.date.hijri.formattedDate} ",
                  style: AppThemes.todayTimeTextStyle),
              TimerWidget()
              // Directionality(
              //   textDirection: TextDirection.ltr,
              //   child: DigitalClock(
              //     is24HourTimeFormat: false,
              //     areaDecoration: BoxDecoration(color: Colors.transparent),
              //     areaAligment: AlignmentDirectional.centerStart,
              //     secondDigitDecoration:
              //         BoxDecoration(color: Colors.transparent),
              //     hourMinuteDigitDecoration:
              //         BoxDecoration(color: Colors.transparent),
              //     hourMinuteDigitTextStyle: AppThemes.timeTimerTextStyle,
              //     secondDigitTextStyle: AppThemes.timeTimerTextStyle,
              //   ),
              // ),
            ],
          ),
          viewModel.canSetPrev
              ? IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    viewModel.prevDay();
                  },
                )
              : SizedBox(
                  width: iconSize,
                )
        ],
      ),
    );
  }
}

class AdanTimesWidget extends ViewModelWidget<AdanVm> {
  const AdanTimesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, AdanVm viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _titleContainer(
                    child: Text("الصلاة",
                        style: AppThemes.azanTimeTitleTextStyle)),
                _titleContainer(
                    child: Text("وقت الصلاة",
                        style: AppThemes.azanTimeTitleTextStyle),
                    isLeft: true)
              ],
            ),
          ),
          ...azanTimes.map(
            (e) => Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _azanContainer(
                    child: Text(e.name),
                    isNextAdan:
                        e.type == viewModel.adanData.timings.nexAdanTime.type,
                  ),
                  _azanContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          viewModel.adanData.timings
                              .getTIimingLocalString(e.type),
                        ),
                        InkWell(
                          onTap: () {
                            viewModel.toggleState(e.type);
                          },
                          child: Image.asset(
                            "assets/alarm/${viewModel.getAzanState(e.type)}.png",
                            width: 25,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),
                    isNextAdan:
                        e.type == viewModel.adanData.timings.nexAdanTime.type,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _azanContainer({Widget child, bool isNextAdan = false}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isNextAdan ? AppColors.adanActive : Colors.transparent,
          border: Border.all(
              color: Colors.black, width: 0.1, style: BorderStyle.solid),
        ),
        child: Center(child: child),
      ),
    );
  }

  _titleContainer({Widget child, bool isLeft = false}) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.2),
              borderRadius: isLeft
                  ? BorderRadius.only(topLeft: Radius.circular(20))
                  : BorderRadius.only(topRight: Radius.circular(20)),
              color: AppColors.mainColorSelected),
          child: Center(child: child)),
    );
  }
}
// class Prayers extends ViewModelWidget<AdanVm> {
//   const Prayers({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, AdanVm vm) {
//     // TODO: implement build
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           ViewModelBuilder<TimerVm>.reactive(
//             builder: (context, timer, ch) => Container(
//               child: Text(
//                 timer.time,
//                 style: AppThemes.timerTextStyle,
//               ),
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: AppColors.adanNormal,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             viewModelBuilder: () => TimerVm(),
//           ),
//           Text("Choose Sound for adan"),
//           FutureBuilder(
//             future: vm.adanTimes,
//             builder:
//                 (BuildContext context, AsyncSnapshot<PrayerTimes> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting)
//                 return LoadingWidget();

//               if (snapshot.hasError) return ErrorWidget(snapshot.error);
//               final data = snapshot.data;
//               return Column(
//                 children: <Widget>[..._timeRow(data)],
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }

//   List<Widget> _timeRow(PrayerTimes pr) {
//     final nxtPrayer =
//         pr.nextPrayer() == Prayer.none ? Prayer.fajr : pr.nextPrayer();
//     return azanTimes.map((e) {
//       final isActive = nxtPrayer == e.type;
//       return e.type == Prayer.none
//           ? SizedBox()
//           : Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Flex(
//                 direction: Axis.horizontal,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(flex: 1, child: SizedBox()),
//                   _container(e.name, isActive: isActive),
//                   Expanded(flex: 1, child: SizedBox()),
//                   _container(pr.timeForPrayer(e.type).myTimeNoSeconds,
//                       isTime: true, isActive: isActive),
//                   Expanded(flex: 1, child: SizedBox()),
//                 ],
//               ),
//             );
//     }).toList();
//   }

//   Widget _container(String text, {isActive = false, isTime = false}) {
//     return Expanded(
//       flex: 8,
//       child: Container(
//         height: 60,
//         padding: EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           color: isActive ? AppColors.adanActive : AppColors.adanNormal,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               AutoSizeText(
//                 text,
//                 maxLines: 1,
//                 style: AppThemes.azanTimeTextStyle,
//                 textAlign: TextAlign.center,
//               ),
//               isTime
//                   ? Container(
//                       width: 40,
//                       height: 40,
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: AppColors.adanNotificationCircle,
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/bell.svg",
//                       ))
//                   : SizedBox()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
