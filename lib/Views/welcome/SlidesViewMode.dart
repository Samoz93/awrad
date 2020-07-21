import 'package:awrad/models/SlideModel.dart';
import 'package:awrad/services/SlidesService.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class SlideViewModel extends FutureViewModel<List<SlideModel>> {
  final ser = Get.find<SlidesService>();

  @override
  Future<List<SlideModel>> futureToRun() {
    return ser.allSlides;
  }
}
