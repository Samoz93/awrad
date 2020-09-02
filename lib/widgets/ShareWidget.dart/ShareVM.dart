import 'package:awrad/services/BookService.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:html/parser.dart';

class ShareVm extends BaseViewModel {
  final _ser = BookService();
  final String link;
  final String name;
  final String html;
  final String uid;
  final bool isPdf;

  ShareVm({
    this.isPdf = false,
    this.html,
    this.link,
    this.name,
    this.uid,
  });
  shareWrd() async {
    setBusy(true);
    if (isPdf) {
      final pth = await _ser.downloadBook(uid, link);
      Share.shareFiles(
        [pth],
        subject: name,
        text: html,
        mimeTypes: ["application/pdf"],
      );
    } else {
      Share.share(removeAllHtmlTags(html), subject: name);
    }
    setBusy(false);
  }

  Stream<double> get pr => _ser.progress;

  String removeAllHtmlTags(String htmlText) {
    final document = parse(htmlText);
    final String parsedString = document.documentElement.text;

    return parsedString;
  }
}
