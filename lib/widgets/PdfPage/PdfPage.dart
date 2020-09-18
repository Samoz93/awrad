import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/widgets/PdfPage/PdfVm.dart';
import 'package:awrad/widgets/ShareWidget.dart/ShareWidget.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:stacked/stacked.dart';

class PdfPage extends StatelessWidget {
  final String uid;
  final String link;
  final String name;
  const PdfPage({Key key, this.uid, this.link, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return link == null || link.isEmpty
        ? Center(
            child: AlertDialog(
            title: Text("خطأ"),
            content: Text("الورد غير متوفر حالياً,سيتم إضافته قريباً !!"),
            actions: <Widget>[
              FlatButton(
                child: Text("تمام"),
                onPressed: () {
                  // model.reportMissing(wrd);
                  // Get.back();
                },
              ),
            ],
          ))
        : ViewModelBuilder<PdfVm>.reactive(
            onModelReady: (v) => v.initBook(),
            viewModelBuilder: () => PdfVm(link: link, uid: uid, name: name),
            builder: (ctx, model, ch) => WillPopScope(
              onWillPop: () async {
                return canCloseTheWindow();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(name),
                      model.isBusy
                          ? SizedBox()
                          : ShareWidget(
                              html: '',
                              isPdf: true,
                              link: link,
                              name: name,
                              uid: uid,
                              soundLink: "",
                            ),
                    ],
                  ),
                ),
                body: model.hasError
                    ? Text(model.modelError)
                    : model.isBusy
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("جاري تحميل الورد"),
                              StreamBuilder(
                                stream: model.progress,
                                initialData: 0.0,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: snapshot.data,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : Stack(
                            children: <Widget>[
                              PdfView(
                                onPageChanged: (page) {
                                  model.setPage(page);
                                },
                                onDocumentLoaded: (s) {
                                  model.notifyListeners();
                                },
                                controller: model.ctrl,
                                scrollDirection: Axis.vertical,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "${model.page}/${model.ctrl.pagesCount}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.mainColor,
                                      fontFamily: "ff"),
                                ),
                              )
                            ],
                          ),
              ),
            ),
          );
  }
}
