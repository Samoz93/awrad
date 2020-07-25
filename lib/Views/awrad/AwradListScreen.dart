import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/awrad/AwradVM.dart';
import 'package:awrad/Views/awrad/ExpansionVM.dart';
import 'package:awrad/models/AwradTypesModel.dart';
import 'package:awrad/widgets/BkScaffold.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:stacked/stacked.dart';

class AwradListScreen extends StatelessWidget {
  final AwradTypesModel type;
  AwradListScreen({Key key, this.type}) : super(key: key);

  final vm = AwradVM();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return BkScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            type.typeName,
            style: AppThemes.pageTitleStyle,
          ),
          leading: Center(
            child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: AppColors.deleteColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: ViewModelBuilder<AwradVM>.reactive(
          builder: (context, model, ch) {
            if (model.isBusy) return LoadingWidget();
            return ListView.builder(
              itemCount: model.awrad.length,
              itemBuilder: (BuildContext context, int index) {
                final wrd = model.awrad[index];
                return ViewModelBuilder<ExpansionVM>.reactive(
                  viewModelBuilder: () => ExpansionVM(id: wrd.uid),
                  builder: (ctx, exVm, ch) => ExpansionTile(
                    initiallyExpanded: false,
                    subtitle: Align(
                      alignment: Alignment.bottomRight,
                      child: ch,
                    ),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          HtmlTextView(data: wrd.wrdDesc),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              exVm.showAlaramOption
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: AppColors
                                                            .deleteColor,
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
                                                      : exVm
                                                          .toggelAlarmOption();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      exVm.hasReminder && !exVm.showAlaramOption
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: AppColors.deleteColor,
                                              ),
                                              onPressed: () {
                                                exVm.deleteNotification(
                                                    showNotification: true);
                                              },
                                            )
                                          : SizedBox(),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        width: exVm.showAlaramOption
                                            ? media.width * 0.84
                                            : 0,
                                        height: exVm.showAlaramOption
                                            ? media.height * 0.2
                                            : 0,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: <Widget>[
                                                ToggleButtons(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  children: <Widget>[
                                                    ...daysOfWeek.map(
                                                      (e) => Text(e.toString()),
                                                    ),
                                                  ],
                                                  isSelected:
                                                      exVm.selectionBool,
                                                  onPressed: (index) {
                                                    exVm.addDay(index);
                                                  },
                                                  color: Colors.red,
                                                ),
                                                ToggleButtons(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  children: <Widget>[
                                                    ...timesOfDay.map(
                                                      (e) => Text(e.toString()),
                                                    ),
                                                  ],
                                                  isSelected:
                                                      exVm.selectionBoolTimes,
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
                          ),
                        ],
                      ),
                    ],
                    title: Text("${index + 1}-${wrd.wrdName}"),
                  ),
                );
              },
            );
          },
          fireOnModelReadyOnce: true,
          staticChild: Text(type.typeName),
          onModelReady: vm.fetchData(type.type),
          viewModelBuilder: () => vm,
        ),
      ),
    );
  }
}
