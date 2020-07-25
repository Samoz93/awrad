import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/models/QuranModel.dart';
import 'package:awrad/services/QuranApi.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class QuranVM extends BaseViewModel {
  final _ser = Get.find<QuranApi>();
  QuranModel _quran;
  QuranModel get quran => _quran;

  initQuarn() async {
    try {
      setBusyForObject(quran, true);
      _quran = await _ser.quran;
      selectedSurah = surahas[0];
      setBusyForObject(quran, false);
      notifyListeners();
    } catch (e) {
      log(e);
    }
  }

  Surahs _selectedSurah;
  Surahs get selectedSurah => _selectedSurah ?? surahas[0];
  set selectedSurah(Surahs sura) {
    _selectedSurah = sura;
    stopPlaying();
    notifyListeners();
  }

  int get selectedSuraCount {
    return _selectedSurah.ayahs.length;
  }

  String get suraText {
    return _selectedSurah.ayahs.fold<String>(
      "",
      (val, e) {
        return val.isEmpty
            ? "${e.text} ${e.sajda ? '۩' : ''} ﴿${e.numberInSurah}﴾"
            : val =
                " $val ${e.text} ${e.sajda ? '۩' : ''} ﴿${e.numberInSurah}﴾  ";
      },
    ).replaceAll("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", "");
  }

  final AssetsAudioPlayer _player = AssetsAudioPlayer();
  String _currentUrl = "";
  // Duration _fullDuration = Duration(seconds: 0);
  // Duration get fullDuration => _fullDuration;
  // set fullDuration(Duration dur) {
  //   _fullDuration = dur;
  //   notifyListeners();
  // }
  ItemScrollController scrollController = ItemScrollController();

  String get currentUrl => _currentUrl;
  set currentUrl(url) {
    // if (_currentUrl == url) return;
    _currentUrl = url;
    _playAudio(url);
    // notifyListeners();
  }

  _playAudio(url) async {
    setBusy(true);
    // await stopPlaying();

    try {
      _player.open(
        Audio.network(url),
        respectSilentMode: true,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        playInBackground: PlayInBackground.enabled,
        showNotification: true,
      );
      // _player.playerState.listen(
      //   (event) {
      //     if (event != PlayerState.play) {
      //       _currentUrl = "";
      //       notifyListeners();
      //     } else {
      //       currentUrl = url;
      //     }
      //   },
      // );
    } catch (e) {
      log(e);
    } finally {
      setBusy(false);
    }
  }

  // Stream<bool> get isPlaying => _player.isPlaying;
  Stream<bool> get isPlaying => _player.isPlaying;
  bool get isPlayingSync => _currentUrl.isNotEmpty;
  Stream<RealtimePlayingInfos> get info => _player.realtimePlayingInfos;
  Stream<Duration> get currentPosition => _player.currentPosition;

  List<Surahs> get surahas =>
      quran?.data?.surahs?.map((e) => e)?.toList() ?? [];

  Future<void> stopPlaying() async {
    setBusy(true);
    await _player.stop();
    _currentUrl = "";
    setBusy(false);
  }

  Future<void> saveBookMark(int index) async {
    final surah = _selectedSurah.number;
    await _ser.saveBookMark(surah, index);
    notifyListeners();
  }

  bool hasKey(int index) {
    return _ser.haskey(_selectedSurah?.number ?? 0, index);
  }

  List<Ayahs> get bookmarks {
    final keys = _ser.getbookMarks(_selectedSurah.number);
    return keys.map((e) => _selectedSurah.ayahs[e]).toList();
  }

  List<int> get bookmarksInt {
    return _ser.getbookMarks(_selectedSurah?.number ?? 1);
  }

  int get bookmarksCount {
    return _ser.getbookMarks(_selectedSurah?.number ?? 1).length;
  }
  // List<String> ayah(String suraName) => quran?.data?.surahs?.where((e) => e.name == suraName).map((e) => e.ayahs.map((g) => g.))?? [];
}
