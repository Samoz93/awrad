import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/models/BookModel.dart';
import 'package:awrad/services/BookService.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:stacked/stacked.dart';

class BookVm extends BaseViewModel {
  final BookModel book;
  final _ser = Get.find<BookService>();
  BookVm({@required this.book}) {}

  PdfController pdfController;

  // PDFDocument _pdf;
  // PDFDocument get pdf => _pdf;
  Stream<double> get progress => _ser.progress;
  initDoc() async {
    try {
      setBusy(true);
      final pth = await _ser.getBook(book);
      final lstPage = _ser.getPage(book.uid);
      pdfController = PdfController(
        document: PdfDocument.openFile(pth),
        initialPage: lstPage,
      );

      // _pdf = await PDFDocument.fromFile(File(pth));
      setBusy(false);
      Future.delayed(
        Duration(milliseconds: 1000),
      ).then(
        (_) => pdfController.jumpToPage(
          lstPage,
          // duration: Duration(milliseconds: 200),
          // curve: Curves.easeInOutBack,
        ),
      );
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> savePage() async {
    await _ser.savePage(book.uid, pdfController.page);
    showSnackBar("تم", "تم حفظ الصفحة  ${pdfController.page}");
  }
}
