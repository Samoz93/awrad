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
  List<Ayahs> data;
  QuranReader _readers;
  final _api = Get.find<QuranApi>();
  final AssetsAudioPlayer player;
  AudiVM(this.data, this.player) {
    _getReaders();
    init();
  }

  _getReaders() async {
    _readers = await _api.readersList;
    notifyListeners();
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

  init() async {
    try {
      if (_shouldStopPlaying) {
        await player.stop();
        final urlList =
            data.map((e) => Audio.network(getPath(e.number, reader))).toList();

        player.open(Playlist(audios: urlList, startIndex: 0),
            loopMode: LoopMode.playlist);
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
    await _api.setReader(val);
    init();
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

  _dis() async {
    // await player.stop();
    // await player.dispose();
  }
}
