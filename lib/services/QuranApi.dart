import 'dart:convert';
import 'dart:developer';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/QuranModel.dart';
import 'package:hive/hive.dart';

class QuranApi {
  // final _dio = Dio();
  final baseUrl = "http://api.alquran.cloud/v1/";
  final box = Hive.box(MAINBOX);
  Future<QuranModel> get quran async {
    try {
      dynamic savedQuran = await box.get(QURAN_BOX);
      log(savedQuran.runtimeType.toString());
      if (savedQuran == null) {
        final str = await getData('/quran/ar.abdurrahmaansudais', baseUrl);
        final value = QuranModel.fromJson(Map<String, dynamic>.from(str));
        final dataString = json.encode(value);
        box.put(QURAN_BOX, dataString);
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
      if (box.containsKey(key)) {
        box.delete(key);
      } else {
        await box.put(key, index);
      }
    } catch (e) {
      log(e);
      throw e;
    }
  }

  haskey(int surah, int index) {
    final key = _getKey(surah, index);
    return box.containsKey(key);
  }

  String _getKey(int sura, int index) {
    return "s${sura}i$index";
  }

  List<int> getbookMarks(int number) {
    final mainKey = "s${number}i";
    return box.keys
        .where((e) => e.toString().contains(mainKey))
        .map((e) => int.parse(e.toString().replaceAll(mainKey, "")))
        .toList();
  }
}
