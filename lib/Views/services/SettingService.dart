import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/SettingsModel.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingService {
  final _db = FirebaseDatabase.instance;

  Stream<SettingMode> get settings {
    return _db.reference().child(SETTING_DB).onValue.map((event) {
      final x = SettingMode.fromMap(getMap(event.snapshot.value));
      return x;
    });
  }
}
