import 'package:awrad/services/QuranApi.dart';
import 'package:get/get.dart';

class QuranService {
  final _rest = Get.find<QuranApi>();
  dynamic _model;

  Future<dynamic> get quran async {
    _model = await _rest.quran;
    return _model;
  }
}
