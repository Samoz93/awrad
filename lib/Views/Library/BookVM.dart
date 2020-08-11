import 'package:awrad/models/BookModel.dart';
import 'package:awrad/services/BookService.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:stacked/stacked.dart';

class BookVm extends BaseViewModel {
  final BookModel book;
  final _ser = Get.find<BookService>();
  BookVm({@required this.book}) {
    _ctrl = PageController(initialPage: _ser.getPage(book.uid).ceil());
  }
  PageController _ctrl;
  PageController get ctrl => _ctrl;

  PdfController pdfController;

  // PDFDocument _pdf;
  // PDFDocument get pdf => _pdf;
  Stream<double> get progress => _ser.progress;
  initDoc() async {
    try {
      setBusy(true);
      final pth = await _ser.getBook(book);
      pdfController = PdfController(
        document: PdfDocument.openFile(pth),
      );

      // _pdf = await PDFDocument.fromFile(File(pth));
      setBusy(false);
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  void savePage(double page) {
    _ser.savePage(book.uid, page);
  }
}
