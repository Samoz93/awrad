import 'package:awrad/services/BookService.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:stacked/stacked.dart';

class PdfVm extends BaseViewModel {
  final String uid;
  final String link;
  final _ser = BookService();
  PdfVm({this.uid, this.link});

  PdfController get ctrl => _ctrl;
  PdfController _ctrl;
  initBook() async {
    setBusy(true);
    final pth = await _ser.downloadBook(uid, link);
    _ctrl = PdfController(document: PdfDocument.openFile(pth));
    setBusy(false);
  }

  int page = 1;
  void setPage(int pg) {
    page = pg;
    notifyListeners();
  }
}
