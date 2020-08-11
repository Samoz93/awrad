import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class TajweedScreen extends StatefulWidget {
  const TajweedScreen({Key key}) : super(key: key);

  @override
  _TajweedScreenState createState() => _TajweedScreenState();
}

class _TajweedScreenState extends State<TajweedScreen> {
  // PDFDocument doc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PdfView(
      scrollDirection: Axis.vertical,
      controller: pdfController,
    );
  }

  final pdfController = PdfController(
    document: PdfDocument.openAsset('assets/adab.pdf'),
  );

//   _initBook() async {
//     final d = await PDFDocument.fromAsset("assets/adab.pdf");
//     setState(() {
//       doc = d;
//     });
//   }
// }
}
