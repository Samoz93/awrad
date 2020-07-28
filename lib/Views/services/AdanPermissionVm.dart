import 'package:awrad/services/LocationService.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class AdanPermissionVm extends BaseViewModel {
  final _locSer = Get.find<LocationSerivce>();

  bool _hasPer = false;
  bool get hasPermission => _hasPer;

  initData() async {
    setBusy(true);
    _hasPer = await _locSer.askForPermissions();
    setBusy(false);
  }
}
