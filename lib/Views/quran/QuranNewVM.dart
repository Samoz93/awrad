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
  int _juzNumber;

  int get currentJuzNumber {
    return selectedSurah.ayahs.first.juz;
  }

  int get nextJuz {
    if (currentJuzNumber >= 30) return -1;
    return currentJuzNumber + 1;
  }

  int get extraNexJuz {
    if (currentJuzNumber >= 30) return -1;
    return currentJuzNumber + 2;
  }

  bool _isJusFahras = false;
  bool get isJuzFahras => _isJusFahras;
  String fahrasString = "فهرسة حسب الحزء";
  set isJuzFahras(val) {
    setBusy(true);
    _isJusFahras = !_isJusFahras;
    if (_isJusFahras) {
      fahrasString = "فهرسة حسب السورة";
    } else {
      fahrasString = "فهرسة حسب الجزء";
    }
    setBusy(false);
  }

  List<Ayahs> juzAyas(int juzNumber) {
    return _quran.data.surahs
        .map((e) => e.ayahs)
        .expand((element) => element)
        .where((element) => element.juz == juzNumber)
        .toList();
  }

  int juzAyasCount(int juzNumber) {
    return juzAyas(juzNumber).length;
  }

  int firstPage(int juzNumber) {
    final x = juzAyas(juzNumber).first;
    return x.page;
  }

  int pageCountInJuz(int juzNumber) {
    final juz = juzAyas(juzNumber);
    return juz.map((e) => e.page).toSet().length;
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  List<int> get juzList {
    return _quran.data.surahs
        .map((e) => e.ayahs.map((f) => f.juz))
        .expand((element) => element)
        .toSet()
        .toList();
  }

  String getSurahNameByJuzNumber(int juzNumber) {
    final juzAyaz = juzAyas(juzNumber);
    return _quran.data.surahs
        .firstWhere((element) => element.ayahs.contains(juzAyaz.first))
        .name;
  }

  List<int> get selectedJuz {
    return selectedSurah.ayahs.map((e) => e.juz).toSet().toList();
  }

  int _selectedSuraIndex = 0;
  int get selectedSuraIndex => _selectedSuraIndex;
  set selectedSuraIndex(index) => _selectedSuraIndex = index;

  int get lastSavedSuraIndex => mainBox.get(LAST_SAVED_SURAH, defaultValue: 0);

  bool isJuz = false;
  initData({String suraName = "", int juzNumber = -1}) async {
    // _ctrl.addListener(_pageListener);
    this._juzNumber = juzNumber;
    try {
      setBusy(true);
      isJuz = juzNumber > -1;
      if (_quran == null) _quran = await _ser.quran;
      if (suraName.isNotEmpty || isJuz) {
        selectedSuraIndex = isJuz
            ? surasString.indexOf(getSurahNameByJuzNumber(juzNumber))
            : surasString.indexOf(suraName);
        selectedSurah = _quran.data.surahs[selectedSuraIndex];
        _jumpToFirstPage(juzNumber);
      } else {
        selectedSuraIndex = lastSavedSuraIndex;
        selectedSurah = _quran.data.surahs[lastSavedSuraIndex];
      }
      setBusy(false);
    } catch (e) {
      // log(e.toString());
    }
  }

  getJusStringForSaving(int juzNumber) {
    return "J$juzNumber";
  }

  _jumpToFirstPage(int juzNumber) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final savedBookMark = isJuz
            ? mainBox.get(getJusStringForSaving(juzNumber), defaultValue: -1)
            : mainBox.get(_selectedSurah.englishName, defaultValue: -1);

        if (savedBookMark < 1) {
          final pageToJumpTo =
              isJuz ? firstPage(juzNumber) : selectedSurah.firstPage;

          ctrl.jumpToPage(indexOfPage(pageToJumpTo));
        } else {
          final pageIndex = indexOfPage(savedBookMark);
          _ctrl.animateToPage(pageIndex,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
      },
    );
  }

  List<int> getJuzPages(int juzNumber) {
    return juzAyas(juzNumber).map((e) => e.page).toSet().toList();
  }

  List<String> get surasString => suras.map((e) => e.name).toList();

  List<Surahs> get suras => _quran.data.surahs.map((e) => e).toList();

  List<int> get pagesNumber => _selectedSurah.listOfPages;

  int _currentPageNumber = 1;
  int get currentPageNumber => _currentPageNumber;
  set currentPageNumber(int index) {
    _currentPageNumber = quran.data.quranPages[index];
    final suraIndex = suras
        .lastIndexWhere((e) => (e.listOfPages.contains(_currentPageNumber)));
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

  bool get isBookMarked {
    final key =
        isJuz ? getJusStringForSaving(_juzNumber) : _selectedSurah.englishName;

    return mainBox.get(key, defaultValue: -1) == currentPageNumber;
  }

  indexOfPage(int pg) {
    return quran.data.quranPages.indexOf(pg);
  }

  saveBookMark() async {
    final isJuz = _juzNumber > -1;
    final key =
        isJuz ? getJusStringForSaving(_juzNumber) : _selectedSurah.englishName;
    if (mainBox.get(key, defaultValue: -1) == currentPageNumber) {
      await mainBox.delete(key);
    } else {
      await mainBox.put(key, currentPageNumber);
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
