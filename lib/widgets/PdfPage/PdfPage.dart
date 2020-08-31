import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/PdfPage/PdfVm.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ViewModelBuilder<PdfVm>.reactive(
        onModelReady: (v) => v.initBook(),
        viewModelBuilder: () => PdfVm(link: link, uid: uid),
        builder: (ctx, model, ch) => model.isBusy
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("جاري تحميل الورد"),
                  LoadingWidget(),
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
                      style:
                          TextStyle(fontSize: 20, color: AppColors.mainColor),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
