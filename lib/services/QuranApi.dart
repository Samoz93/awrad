import 'dart:convert';
import 'dart:developer';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/main.dart';
import 'package:awrad/models/QuranModel.dart';

class QuranApi {
  final baseUrl = "http://api.alquran.cloud/v1/";
  Future<QuranModel> get quran async {
    try {
      dynamic savedQuran = await mainBox.get(QURAN_BOX);
      log(savedQuran.runtimeType.toString());
      if (savedQuran == null) {
        final str = await getData('/quran/ar.abdurrahmaansudais', baseUrl);
        final value = QuranModel.fromJson(Map<String, dynamic>.from(str));
        final dataString = json.encode(value);
        mainBox.put(QURAN_BOX, dataString);
        return value;
      }
      return QuranModel.fromJson(json.decode(savedQuran));
    } catch (e) {
      throw e;
    }
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
