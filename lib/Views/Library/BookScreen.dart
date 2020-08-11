import 'package:awrad/Views/Library/BookVM.dart';
import 'package:awrad/models/BookModel.dart';
import 'package:awrad/widgets/MyErrorWidget.dart';
import 'package:awrad/widgets/MyScf.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:stacked/stacked.dart';

class BookScreen extends StatelessWidget {
  final BookModel book;
  BookScreen({Key key, this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: book.bookName,
      child: Center(
        child: ViewModelBuilder<BookVm>.reactive(
          builder: (context, model, ch) => model.hasError
              ? MyErrorWidget(err: model.modelError)
              : model.isBusy
                  ? StreamBuilder(
                      stream: model.progress,
                      initialData: 0.0,
                      builder: (BuildContext context,
                          AsyncSnapshot<double> snapshot) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("جاري تحميل الكتاب "),
                              SizedBox(height: 20),
                              CircularProgressIndicator(
                                value: snapshot.data ?? 0.0,
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Stack(
                      children: <Widget>[
                        PdfView(
                          controller: model.pdfController,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton(
                            onPressed: () {
                              model.savePage(model.ctrl.page);
                            },
                            child: Text("احفظ"),
                          ),
                        )
                      ],
                    ),
          viewModelBuilder: () => BookVm(book: book),
          onModelReady: (md) => md.initDoc(),
        ),
      ),
    );
  }
}
