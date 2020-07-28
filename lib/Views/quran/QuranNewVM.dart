import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import 'package:awrad/models/QuranModel.dart';
import 'package:awrad/services/QuranApi.dart';

class QuranNewVM extends BaseViewModel {
  final _ser = Get.find<QuranApi>();
  QuranModel _quran;
  QuranModel get quran => _quran;

  initData() async {
    setBusy(true);
    _quran = await _ser.quran;
    selectedSurah = _quran.data.surahs[3];
    setBusy(false);
  }

  List<QuranPage> _pages = [];
  List<QuranPage> get pages => _pages;

  getPages() {
    _pages.clear();
    _selectedSurah.ayahs.forEach((aya) {
      final page = _getPage(aya.page);
      page.suraName = _selectedSurah.name;
      page.text.add(
          aya..text.replaceAll("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", ""));
      page.pageNumer = aya.page;
      _savePage(page);
    });
    notifyListeners();
  }

  QuranPage _getPage(int pageNum) {
    return _pages.firstWhere((element) => element.pageNumer == pageNum,
        orElse: () => QuranPage(text: []));
  }

  _savePage(QuranPage page) {
    final index = _pages.indexWhere((e) => e.pageNumer == page.pageNumer);
    if (index > -1)
      _pages[index] = page;
    else
      _pages.add(page);
  }

  Surahs _selectedSurah;
  Surahs get selectedSurah => _selectedSurah;
  set selectedSurah(Surahs sura) {
    _selectedSurah = sura;
    getPages();
    notifyListeners();
  }

  int ss = 1;
  void selectNextSurah() {
    ss++;
    selectedSurah = _quran.data.surahs[ss];
  }
}

class QuranPage {
  String suraName;
  int pageNumer;
  List<Ayahs> text = [];
  QuranPage({
    this.suraName,
    this.pageNumer,
    this.text,
  });

  QuranPage copyWith({
    String suraName,
    int pageNumer,
    List<Ayahs> text,
  }) {
    return QuranPage(
      suraName: suraName ?? this.suraName,
      pageNumer: pageNumer ?? this.pageNumer,
      text: text ?? this.text,
    );
  }

  @override
  String toString() =>
      'QuranPage(suraName: $suraName, pageNumer: $pageNumer, text: $text)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is QuranPage &&
        o.suraName == suraName &&
        o.pageNumer == pageNumer &&
        listEquals(o.text, text);
  }

  @override
  int get hashCode => suraName.hashCode ^ pageNumer.hashCode ^ text.hashCode;
}
