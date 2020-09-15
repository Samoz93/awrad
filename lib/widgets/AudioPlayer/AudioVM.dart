import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/models/QuranModel.dart';
import 'package:awrad/models/Readears.dart';
import 'package:awrad/services/QuranApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class AudiVM extends BaseViewModel {
  int pageNumber;
  QuranReader _readers;
  List<Ayahs> data;
  QuranModel _quran;
  final _api = Get.find<QuranApi>();
  final AssetsAudioPlayer player;
  String wantedSura;
  AudiVM(this.pageNumber, this.player) {
    init();
  }

  _getReaders() async {
    setBusy(true);
    _readers = await _api.readersList;
    if (_quran == null) {
      _quran = await _api.quran;
    }
    final availableSura =
        _quran.data.surahs.fold<Set<String>>(Set(), (p, element) {
      final aya = element.ayahs.where((a) => a.page == pageNumber);
      if (aya.isNotEmpty) return p..add(element.name);
      return p;
    }).toList();
    final _playingSound = await _playingSura;
    if (availableSura.length > 1) {
      if (_playingSound.isNotEmpty) {
        wantedSura = _playingSound;
      } else {
        wantedSura = await Get.dialog(
          Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text("اختر سورة"),
              content: Text(
                  "يوجد اكثر من سورة في الصفحة الحالية , اي السور تود سماعها ؟"),
              actions: <Widget>[
                ...availableSura.map((e) => FlatButton(
                      child: Text(e),
                      onPressed: () {
                        Get.back(result: e);
                      },
                    ))
              ],
            ),
          ),
        );
        if (wantedSura == null || wantedSura.isEmpty)
          wantedSura = availableSura.first;
      }
    } else {
      wantedSura = availableSura.first;
    }

    data = _quran.data.surahs.fold<List<Ayahs>>([], (p, element) {
      final aya = element.ayahs.where((a) => a.page == pageNumber);
      if (element.name == wantedSura) return p..addAll(aya);
      return p;
    }).toList();
    setBusy(false);
  }

  bool get _shouldStopPlaying {
    if (player == null || player.current == null) return true;
    if (player.playlist.isNullOrBlank) return true;
    final theSameSize = player.playlist.numberOfItems == data.length;
    if (!theSameSize) return true;
    final firstPlaying = player.playlist.audios.first.path;
    final firstInList = getPath(data.first.number, reader);
    return firstPlaying != firstInList;
  }

  Future<String> get _playingSura async {
    if (player == null || player.current == null) return "";
    if (player.playlist.isNullOrBlank) return "";
    final firstPlaying = (await player.realtimePlayingInfos.first).current;
    if (firstPlaying == null) return "";
    final runningAudio = firstPlaying.audio.audio.path;
    final ayaNumber = runningAudio.substring(
        runningAudio.lastIndexOf("/") + 1, runningAudio.length);
    final g = _quran.data.surahs
        .where((element) =>
            element.ayahs.where((n) => n.page == pageNumber).isNotEmpty)
        .toList();
    final aya = g.firstWhere(
        (element) => element.ayahs.where((x) {
              return x.number.toString() == ayaNumber;
            }).isNotEmpty,
        orElse: () => null);
    final isPlaying = (await player.playerState.first) == PlayerState.play;
    if (!isPlaying) return "";
    return aya == null ? "" : aya.name;
  }

  init() async {
    try {
      await _getReaders();
      if (_shouldStopPlaying) {
        await player.stop();
        final urlList = data
            .map(
              (e) => Audio.network(
                getPath(e.number, reader),
                metas: Metas(
                    artist: wantedSura,
                    album: readerAr,
                    image: MetasImage.network(
                        "https://www.alislam.org/wp-content/uploads/2018/04/quran.jpg"),
                    title: "الاية ${e.numberInSurah}"),
              ),
            )
            .toList();

        player.open(
          Playlist(audios: urlList, startIndex: 0),
          loopMode: LoopMode.playlist,
          showNotification: true,

          headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
          // notificationSettings: NotificationSettings(
          //   playPauseEnabled: true,
          //   seekBarEnabled: true,
          //   prevEnabled: true,
          // ),
        );
      } else {
        player.playOrPause();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  String get reader => _api.deafultQuranReader;
  String get readerAr => _api.deafultQuranReaderAR;
  next() {
    player.next();
  }

  List<DropdownMenuItem<String>> get items => _readers.data
      .map(
        (e) => DropdownMenuItem<String>(
          child: Center(
            child: Text(
              e.name,
              textAlign: TextAlign.center,
            ),
          ),
          value: e.identifier,
        ),
      )
      .toList();

  changeReader(val) async {
    setBusy(true);
    await _api.setReader(val);
    await init();
    setBusy(false);
  }

  faster() async {
    final currentPlaySpeed = await player.playSpeed.take(1).first;
    if (currentPlaySpeed > 1.3) return;
    player.setPlaySpeed(currentPlaySpeed + 0.1);
  }

  slower() async {
    final currentPlaySpeed = await player.playSpeed.take(1).first;
    if (currentPlaySpeed > 0.7) return;
    player.setPlaySpeed(currentPlaySpeed - 0.1);
  }

  prev() {
    player.previous();
  }

  void pause() {
    player.pause();
  }

  void stop() {
    player.stop();
  }

  @override
  void dispose() {
    super.dispose();
    _dis();
  }

  String get getAyahName {
    final index = player.readingPlaylist.currentIndex;
    final x = data[index];
    return x.numberInSurah.toString();
  }

  String get getSurahName {
    final index = player.readingPlaylist.currentIndex;
    final x = data[index];
    final sura = _quran.data.surahs
        .firstWhere((e) => e.ayahs.any((g) => g.audio == x.audio));
    return sura.name;
  }

  _dis() async {
    // await player.stop();
    // await player.dispose();
  }
}
