import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awrad/models/BookModel.dart';
import 'package:awrad/services/BookService.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class BookVm extends BaseViewModel {
  final BookModel book;
  final _ser = Get.find<BookService>();
  BookVm({@required this.book}) {
    _ctrl = PageController(initialPage: _ser.getPage(book.uid).ceil());
  }
  PageController _ctrl;
  PageController get ctrl => _ctrl;
  PDFDocument _pdf;
  PDFDocument get pdf => _pdf;
  Stream<double> get progress => _ser.progress;
  initDoc() async {
    try {
      setBusy(true);
      final pth = await _ser.getBook(book);
      _pdf = await PDFDocument.fromFile(File(pth));
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
