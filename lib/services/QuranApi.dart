import 'dart:convert';
import 'dart:developer';

import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/main.dart';
import 'package:awrad/models/QuranModel.dart';
import 'package:awrad/models/Readears.dart';
import 'package:flutter/services.dart';

class QuranApi {
  QuranReader _readers;
  Future<QuranModel> get quran async {
    try {
      String data = await rootBundle.loadString("assets/json/quran.json");
      final jsonResult = json.decode(data);

      return QuranModel.fromJson(jsonResult);
    } catch (e) {
      throw e;
    }
  }

  Future<QuranReader> get readersList async {
    try {
      if (_readers != null) return _readers;
      String data = await rootBundle.loadString("assets/json/Readers.json");
      final jsonResult = json.decode(data);

      // dynamic savedQuran = await mainBox.get(QURAN_BOX);
      // log(savedQuran.runtimeType.toString());
      // if (savedQuran == null) {
      //   final str = await getData('/quran/ar.abdurrahmaansudais', baseUrl);
      //   final value = QuranModel.fromJson(Map<String, dynamic>.from(str));
      //   final dataString = json.encode(value);
      //   mainBox.put(QURAN_BOX, dataString);
      //   return value;
      // }
      _readers = QuranReader.fromJson(jsonResult);

      return _readers;
    } catch (e) {
      throw e;
    }
  }

  setReader(String readerUid) async {
    await mainBox.put(QURAN_READER, readerUid);
  }

  String get deafultQuranReader {
    return mainBox.get(QURAN_READER, defaultValue: "ar.parhizgar");
  }

  String get deafultQuranReaderAR {
    final g = _readers.data.firstWhere(
        (e) => e.identifier == deafultQuranReader,
        orElse: () => null);
    return g?.name ?? "what";
  }

  Future<void> saveBookMark(int surah, int index) async {
    try {
      final key = _getKey(surah, index);
      if (mainBox.containsKey(key)) {
        mainBox.delete(key);
      } else {
        await mainBox.put(key, index);
      }
    } catch (e) {
      log(e);
      throw e;
    }
  }

  haskey(int surah, int index) {
    final key = _getKey(surah, index);
    return mainBox.containsKey(key);
  }

  String _getKey(int sura, int index) {
    return "s${sura}i$index";
  }

  List<int> getbookMarks(int number) {
    final mainKey = "s${number}i";
    return mainBox.keys
        .where((e) => e.toString().contains(mainKey))
        .map((e) => int.parse(e.toString().replaceAll(mainKey, "")))
        .toList();
  }
}
