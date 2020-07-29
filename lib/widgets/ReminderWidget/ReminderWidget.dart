import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/Views/quran/QuranNewScreen.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/ReminderWidget/ReminderWidgetVM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class ReminderWidget extends StatelessWidget {
  final String uid;
  final Function deleteFunction;
  const ReminderWidget({Key key, this.uid, @required this.deleteFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReminderWidgetVm>.reactive(
      viewModelBuilder: () => ReminderWidgetVm(uid),
      disposeViewModel: true,
      builder: (ctx, model, ch) {
        return model.isBusy
            ? LoadingWidget()
            : InkWell(
                onTap: () {
                  if (model.reminder.isAwrad)
                    Get.dialog(
                      Dialog(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Html(
                              data: model.reminder.wrdText,
                              style: {
                                "*": Style(
                                  textAlign: TextAlign.center,
                                ),
                              },
                              shrinkWrap: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  else
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuranNewScreen(
                        suraName: model.reminder.wrdName,
                      ),
                    ));
                },
                child: Dismissible(
                  key: Key(model.reminder.id),
                  onDismissed: (dir) {
                    deleteFunction();
                  },
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: AppColors.deleteColor,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "حذف",
                          textAlign: TextAlign.start,
                          style: AppThemes.deleteInfoTextStyle,
                        ),
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return confirmMessage(
                        "هل أنت متأكد من حذفك لهذا التنبيه ؟");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  model.reminder.wrdName,
                                  style: AppThemes.wrdTitleTextStyle,
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "سيتم التذكير في : ${model.daysString}",
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    "سيتم تذكيرك بعد : ${model.timeString}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (await confirmMessage(
                                  "هل أنت متأكد من حذفك لهذا التنبيه ؟"))
                                deleteFunction();
                            },
                            child: Icon(
                              Icons.alarm_off,
                              color: AppColors.deleteColor,
                              size: 40,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
