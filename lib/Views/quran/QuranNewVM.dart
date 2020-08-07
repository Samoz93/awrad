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

  // Future<bool> get isPlaying => player.isPlaying.first;

  // bool get shouldStopPlaying {
  //   if (player == null || player.current == null) return false;
  //   if (player.playlist.isNullOrBlank) return false;
  //   final theSameSize = player.playlist.numberOfItems == ayahSounds.length;
  //   if (!theSameSize) return true;
  //   final firstPlaying = player.playlist.audios.first.path;
  //   final firstInList =
  //       getPath(ayahSounds.first.number, _api.deafultQuranReader);
  //   return firstPlaying != firstInList;
  // }

  int get lastSavedSuraIndex => mainBox.get(LAST_SAVED_SURAH, defaultValue: 0);
  initData({String suraName = ""}) async {
    setBusy(true);
    if (_quran == null) _quran = await _ser.quran;
    if (suraName.isNotEmpty) {
      final index = surasString.indexOf(suraName);
      selectedSurah = _quran.data.surahs[index];
    } else {
      selectedSurah = _quran.data.surahs[lastSavedSuraIndex];
    }
    setBusy(false);
  }

  List<String> get surasString =>
      _quran.data.surahs.map((e) => e.name).toList();

  List<Surahs> get suras => _quran.data.surahs.map((e) => e).toList();

  List<int> get pagesNumber =>
      _selectedSurah.ayahs.map((e) => e.page).toSet().toList();

  int _currentPageNumber;
  int get currentPageNumber => _currentPageNumber;
  set currentPageNumber(int number) {
    _currentPageNumber = pagesNumber[number];
    notifyListeners();
  }

  Surahs _selectedSurah;
  Surahs get selectedSurah => _selectedSurah;
  set selectedSurah(Surahs sura) {
    try {
      _selectedSurah = sura;
      _currentPageNumber = pagesNumber[0];

      Future.delayed(Duration(milliseconds: 500)).then((_) {
        final savedBookMark =
            mainBox.get(_selectedSurah.englishName, defaultValue: -1);
        int pageIndex = 0;

        if (savedBookMark > -1) {
          pageIndex = indexOfPage(savedBookMark);
        }
        _ctrl.animateToPage(pageIndex,
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  saveSura() async {
    final x = suras.indexOf(_selectedSurah);
    log(x.toString());
    await mainBox.put(LAST_SAVED_SURAH, x);
    notifyListeners();
  }

  bool get isBookMarked =>
      mainBox.get(_selectedSurah.englishName, defaultValue: -1) ==
      currentPageNumber;

  indexOfPage(int pg) {
    return pagesNumber.indexOf(pg);
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
  // int ss = 1;
  // void selectNextSurah() {
  //   ss++;
  //   selectedSurah = _quran.data.surahs[ss];
  // }
}

// class QuranPage {
//   String suraName;
//   int pageNumer;
//   List<Ayahs> text = [];
//   QuranPage({
//     this.suraName,
//     this.pageNumer,
//     this.text,
//   });

//   QuranPage copyWith({
//     String suraName,
//     int pageNumer,
//     List<Ayahs> text,
//   }) {
//     return QuranPage(
//       suraName: suraName ?? this.suraName,
//       pageNumer: pageNumer ?? this.pageNumer,
//       text: text ?? this.text,
//     );
//   }

//   @override
//   String toString() =>
//       'QuranPage(suraName: $suraName, pageNumer: $pageNumer, text: $text)';

//   @override
//   bool operator ==(Object o) {
//     if (identical(this, o)) return true;

//     return o is QuranPage &&
//         o.suraName == suraName &&
//         o.pageNumer == pageNumer &&
//         listEquals(o.text, text);
//   }

//   @override
//   int get hashCode => suraName.hashCode ^ pageNumer.hashCode ^ text.hashCode;
// }
