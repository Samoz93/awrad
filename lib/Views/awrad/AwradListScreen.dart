import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Views/awrad/AwradVM.dart';
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
          leading: Icon(
            Icons.ac_unit,
            color: Colors.red,
          ),
        ),
        body: ViewModelBuilder<AwradVM>.reactive(
            builder: (context, model, ch) {
              if (model.isBusy) return LoadingWidget();
              return ListView.builder(
                itemCount: model.awrad.length,
                itemBuilder: (BuildContext context, int index) {
                  final wrd = model.awrad[index];
                  return ExpansionTile(
                    initiallyExpanded: false,
                    subtitle: Align(
                      alignment: Alignment.bottomRight,
                      child: ch,
                    ),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Center(
                                child: IconButton(
                                  icon: Icon(Icons.alarm_add),
                                  onPressed: () {
                                    model.toggelAlarmOption();
                                  },
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: model.showAlaramOption
                                    ? media.width * 0.84
                                    : 0,
                                height: model.showAlaramOption ? 50 : 0,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ToggleButtons(
                                    borderRadius: BorderRadius.circular(8),
                                    children: <Widget>[
                                      ...daysOfWeek.map(
                                        (e) => Text(e.toString()),
                                      ),
                                    ],
                                    isSelected: [
                                      ...daysOfWeek.map(
                                          (e) => model.selectedList.contains(e))
                                    ],
                                    onPressed: (index) {
                                      model.addDay(daysOfWeek[index]);
                                    },
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          HtmlTextView(data: wrd.wrdDesc)
                        ],
                      ),
                    ],
                    title: Text(wrd.wrdName),
                  );
                },
              );
            },
            fireOnModelReadyOnce: true,
            staticChild: Text(type.typeName),
            onModelReady: vm.fetchData(type.type),
            viewModelBuilder: () => vm),
      ),
    );
  }
}
