import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/main.dart';
import 'package:firebase_database/firebase_database.dart';

class SignService {
  final _db = FirebaseDatabase.instance;
  Map<String, dynamic> _map;
  getDataFromInternet() async {
    final data = (await _db.reference().child("signs").once()).value;
    _map = Map<String, String>.from(data);
    mainBox.put(SIGNS_AZAN, data);
    return _map;
  }

  Future<Map<String, dynamic>> get symbols async {
    if (_map != null) return _map;
    final str = mainBox.get(SIGNS_AZAN);
    if (str == null) {
      await getDataFromInternet();
      return _map;
    } else {
      getDataFromInternet();
      _map = Map<String, String>.from(str);
      return _map;
    }
  }
}
