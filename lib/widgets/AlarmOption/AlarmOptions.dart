import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/widgets/AlarmOption/ExpansionVM.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AlarmOptions extends ViewModelWidget<ExpansionVM> {
  final WrdModel wrd;
  const AlarmOptions({Key key, @required this.wrd}) : super(key: key);

  @override
  Widget build(BuildContext context, ExpansionVM exVm) {
    final media = MediaQuery.of(context).size;
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
                      child: Column(
                        children: <Widget>[
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(8),
                            children: <Widget>[
                              ...daysOfWeek.map(
                                (e) => Text(e),
                              ),
                            ],
                            isSelected: exVm.selectionBool,
                            onPressed: (index) {
                              exVm.addDay(index);
                            },
                            color: Colors.red,
                          ),
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(8),
                            children: <Widget>[
                              ...timesOfDay.map(
                                (e) => Text(e.toString()),
                              ),
                            ],
                            isSelected: exVm.selectionBoolTimes,
                            onPressed: (index) {
                              exVm.addTime(index);
                            },
                            color: Colors.red,
                          ),
                        ],
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
