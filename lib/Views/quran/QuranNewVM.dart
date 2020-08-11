import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import 'package:awrad/models/QuranModel.dart';
import 'package:awrad/services/QuranApi.dart';

class QuranNewVM extends BaseViewModel {
  final _ser = Get.find<QuranApi>();
  QuranModel _quran;
  QuranModel get quran => _quran;
  PageController _ctrl = PageController(initialPage: 0);
  PageController get ctrl => _ctrl;
  final player = AssetsAudioPlayer.newPlayer();
  // final _api = Get.find<QuranApi>();
  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  int _selectedSuraIndex = 0;
  int get selectedSuraIndex => _selectedSuraIndex;
  set selectedSuraIndex(index) => _selectedSuraIndex = index;

  int get lastSavedSuraIndex => mainBox.get(LAST_SAVED_SURAH, defaultValue: 0);
  initData({String suraName = ""}) async {
    // _ctrl.addListener(_pageListener);
    try {
      setBusy(true);
      if (_quran == null) _quran = await _ser.quran;
      if (suraName.isNotEmpty) {
        selectedSuraIndex = surasString.indexOf(suraName);
        selectedSurah = _quran.data.surahs[selectedSuraIndex];
        _jumpToFirstPage();
      } else {
        selectedSuraIndex = lastSavedSuraIndex;
        selectedSurah = _quran.data.surahs[lastSavedSuraIndex];
      }
      setBusy(false);
    } catch (e) {
      log(e.toString());
    }
  }

  _jumpToFirstPage() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final savedBookMark =
            mainBox.get(_selectedSurah.englishName, defaultValue: -1);

        if (savedBookMark < 1) {
          ctrl.jumpToPage(indexOfPage(selectedSurah.firstPage));
        } else {
          final pageIndex = indexOfPage(savedBookMark);
          _ctrl.animateToPage(pageIndex,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      },
    );
  }

  List<String> get surasString => suras.map((e) => e.name).toList();

  List<Surahs> get suras => _quran.data.surahs.map((e) => e).toList();

  List<int> get pagesNumber => _selectedSurah.listOfPages;

  int _currentPageNumber = 1;
  int get currentPageNumber => _currentPageNumber;
  set currentPageNumber(int index) {
    _currentPageNumber = quran.data.quranPages[index];
    final suraIndex = suras.indexWhere((e) =>
        (_currentPageNumber >= e.firstPage &&
            _currentPageNumber <= e.lastPage));
    selectedSurah = suras[suraIndex];
    selectedSuraIndex = suraIndex;
    notifyListeners();
  }

  Surahs get nextSurah {
    final nextIndex = selectedSuraIndex + 1;
    if (nextIndex >= suras.length - 1) return null;
    return suras[nextIndex];
  }

  Surahs get extraNextSurah {
    final nextIndex = selectedSuraIndex + 2;
    if (nextIndex >= suras.length - 1) return null;
    return suras[nextIndex];
  }

  Surahs _selectedSurah;
  Surahs get selectedSurah => _selectedSurah;
  set selectedSurah(Surahs sura) {
    _selectedSurah = sura;
    notifyListeners();
  }

  saveSura() async {
    final x = suras.indexOf(_selectedSurah);
    await mainBox.put(LAST_SAVED_SURAH, x);
    notifyListeners();
  }

  bool get isBookMarked =>
      mainBox.get(_selectedSurah.englishName, defaultValue: -1) ==
      currentPageNumber;

  indexOfPage(int pg) {
    return quran.data.quranPages.indexOf(pg);
  }

  saveBookMark() async {
    if (mainBox.get(_selectedSurah.englishName, defaultValue: -1) ==
        currentPageNumber) {
      await mainBox.delete(_selectedSurah.englishName);
    } else {
      await mainBox.put(_selectedSurah.englishName, currentPageNumber);
    }
    notifyListeners();
  }

  List<Ayahs> get ayahSounds {
    final x = _selectedSurah.ayahs
        .where((e) => e.page == _currentPageNumber)
        .map((e) => e)
        .toList();
    return x;
  }
}
