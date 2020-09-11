import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/widgets/Schedular2/SchedularVM.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Schedular2 extends StatelessWidget {
  const Schedular2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ViewModelBuilder<Schedular2Vm>.reactive(
            viewModelBuilder: () => Schedular2Vm(),
            builder: (ctx, model, ch) => Column(
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
                            model.selectedDay = e.dateWeek;
                          },
                          child: CheckButton(
                            isSelected: model.selectedDay == e.dateWeek,
                            text: e.name,
                            perc: model.getPercentage(e.dateWeek),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                            model.addTimes(e.type);
                          },
                          child: CheckButton(
                            isSelected: model.isTimeSelected(e.type),
                            text: e.name,
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
    );
  }
}

class CheckButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final double perc;
  final double height;
  final bool hasPerc;
  const CheckButton(
      {Key key,
      this.text,
      this.isSelected,
      this.perc,
      this.height = 40,
      this.hasPerc = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.2)
              : perc > 0
                  ? AppColors.mainColor.withOpacity(0.3)
                  : Colors.transparent,
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.1),
        ),
        height: height,
        child: hasPerc
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      text,
                      style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.red),
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    height: height * 0.1,
                    width: constraints.maxWidth * perc,
                  ),
                ],
              )
            : Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.red,
                  ),
                ),
              ),
      ),
    );
  }
}
