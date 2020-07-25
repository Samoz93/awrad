import 'dart:convert';
import 'dart:developer';

import 'package:awrad/models/QuranModel.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class QuranApi {
  final _dio = Dio();
  final baseUrl = "http://api.alquran.cloud/v1/";
  final box = Hive.box("main");
  Future<QuranModel> get quran async {
    try {
      //TODO check
      // await box.delete("Quran");
      dynamic savedQuran = await box.get("Quran");
      log(savedQuran.runtimeType.toString());
      // dynamic savedQuran;
      if (savedQuran == null) {
        final str = await _getData('/quran/ar.abdurrahmaansudais');
        final value = QuranModel.fromJson(Map<String, dynamic>.from(str));
        final dataString = json.encode(value);
        box.put("Quran", dataString);
        return value;
      }
      return QuranModel.fromJson(json.decode(savedQuran));
    } catch (e) {
      throw e;
    }
  }

  _getData(String path) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(path,
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return _result.data;
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
        .where((e) => (e as String).contains(mainKey))
        .map((e) => int.parse((e as String).replaceAll(mainKey, "")))
        .toList();
  }
}
