import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'SchedularViewModel.dart';

class SchedularWidget extends StatelessWidget {
  const SchedularWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ViewModelBuilder<SchedularViewModel>.reactive(
          builder: (ctx, model, ch) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...model.times.map(
                (r) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...model.days.map(
                      (c) => r == 0 && c == 0
                          ? Container(width: 50)
                          : r == 0
                              ? Text("${model.getDay(c)}")
                              : c == 0
                                  ? Container(
                                      width: 50, child: Text(model.getTime(r)))
                                  : Checkbox(
                                      onChanged: (v) => model.addTimes(c, r),
                                      value: model.isChecked(c, r),
                                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          viewModelBuilder: () => SchedularViewModel(),
        ),
      )),
    );
  }
}
