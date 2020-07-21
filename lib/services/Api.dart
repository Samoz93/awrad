import 'dart:convert';

import 'package:awrad/models/QuranModel.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class Api {
  final _dio = Dio();
  final baseUrl = "http://api.alquran.cloud/v1/";
  final box = Hive.box("main");
  Future<QuranModel> get quran async {
    try {
      //TODO check
      dynamic savedQuran = box.get("Quran");
      if (savedQuran == null) {
        final str = await _getData('/quran/ar.asad');
        final value = QuranModel.fromJson(Map<String, dynamic>.from(str));
        final dataString = json.encode(value);
        box.put("Quran", dataString);
        return value;
      }
      return json.decode(savedQuran);
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
}
