import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:awrad/widgets/MyScf.dart';
import 'package:flutter/material.dart';

class TajweedScreen extends StatefulWidget {
  const TajweedScreen({Key key}) : super(key: key);

  @override
  _TajweedScreenState createState() => _TajweedScreenState();
}

class _TajweedScreenState extends State<TajweedScreen> {
  PDFDocument doc;

  @override
  void initState() {
    super.initState();
    _initBook();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "آداب القرآن",
      child: doc == null
          ? LoadingWidget()
          : Container(
              height: double.infinity,
              width: double.infinity,
              child: PDFViewer(
                scrollDirection: Axis.vertical,
                document: doc,
                showPicker: false,
              ),
            ),
    );
  }

  _initBook() async {
    final d = await PDFDocument.fromAsset("assets/adab.pdf");
    setState(() {
      doc = d;
    });
  }
}
