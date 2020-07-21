import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';

// import 'package:native_pdf_view/native_pdf_view.dart';

class QuranScreen extends StatelessWidget {
  QuranScreen({Key key}) : super(key: key);
  // final pdfController = PdfController(
  //   document: PdfDocument.openAsset('assets/quran.pdf'),
  // );

  // Widget pdfView() => PdfView(
  //       controller: pdfController,
  //       onPageChanged: (p) => log(p.toString()),
  //       scrollDirection: Axis.horizontal,
  //     );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PDFDocument.fromAsset("assets/quran.pdf"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
          return PDFViewer(
            showNavigation: true,
            document: snapshot.data,
            showIndicator: true,
            showPicker: false,
            enableSwipeNavigation: true,
            indicatorText: Colors.red,
            zoomSteps: 10,
          );

        return LoadingWidget();
      },
    );
  }
}
