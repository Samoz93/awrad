import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/widgets/AlarmOption/ExpansionVM.dart';
import 'package:awrad/widgets/Schedular2/Schedular2.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AlarmOptions extends ViewModelWidget<ExpansionVM> {
  final WrdModel wrd;
  const AlarmOptions({Key key, @required this.wrd}) : super(key: key);

  @override
  Widget build(BuildContext context, ExpansionVM exVm) {
    final media = MediaQuery.of(context).size;
    final iconSize = 30.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: exVm.showAlaramOption
                      ? media.height * 0.2
                      : media.height * 0.07,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        exVm.showAlaramOption
                            ? IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  size: iconSize,
                                  color: AppColors.deleteColor,
                                ),
                                onPressed: () {
                                  exVm.toggelAlarmOption();
                                },
                              )
                            : SizedBox(),
                        IconButton(
                          icon: Icon(
                            exVm.showAlaramOption
                                ? Icons.check_circle
                                : Icons.alarm_add,
                            size: iconSize,
                            color: AppColors.addColor,
                          ),
                          onPressed: () {
                            exVm.showAlaramOption
                                ? exVm.saveDate()
                                : exVm.toggelAlarmOption();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                exVm.hasReminder && !exVm.showAlaramOption
                    ? IconButton(
                        icon: Icon(
                          Icons.alarm_off,
                          size: iconSize,
                          color: AppColors.deleteColor,
                        ),
                        onPressed: () {
                          exVm.deleteNotification(wrd.uid,
                              showNotification: true);
                        },
                      )
                    : SizedBox(),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: exVm.showAlaramOption ? media.width * 0.84 : 0,
                  height: exVm.showAlaramOption ? media.height * 0.2 : 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: media.width,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...daysOfWeek2.map(
                                  (e) => Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: InkWell(
                                      onTap: () {
                                        exVm.selectedDay = e.dateWeek;
                                      },
                                      child: CheckButton(
                                        isSelected:
                                            exVm.selectedDay == e.dateWeek,
                                        text: e.name,
                                        perc: exVm.getPercentage(e.dateWeek),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...azanTimes.map(
                                  (e) => Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: InkWell(
                                      onTap: () {
                                        exVm.addTimes(e.type);
                                      },
                                      child: CheckButton(
                                        isSelected: exVm.isTimeSelected(e.type),
                                        text: e.name,
                                        hasPerc: false,
                                        perc: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
