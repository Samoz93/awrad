import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/services/BookService.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:html/parser.dart';

class ShareVm extends BaseViewModel {
  final _ser = BookService();
  final String link;
  final String name;
  final String html;
  final String soundLink;
  final String uid;
  final bool isPdf;

  ShareVm({
    this.isPdf = false,
    this.html,
    this.link,
    this.name,
    this.uid,
    @required this.soundLink,
  });
  shareWrd() async {
    setBusy(true);
    if (isPdf) {
      final List<String> pthList = [];

      final _pth = await _ser.downloadBook(uid: uid, link: link);
      pthList.add(_pth);
      if (soundLink.isNotEmpty) {
        final _soundPth = await _ser.downloadSound(uid: uid, link: soundLink);
        pthList.add(_soundPth);
      }
      Share.shareFiles(
        pthList,
        subject: shareLink,
      );
    } else {
      Share.share(
        removeAllHtmlTags(html),
        subject: shareLink,
      );
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
