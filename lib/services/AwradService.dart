import 'dart:developer';

import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/models/AwradTypesModel.dart';
import 'package:awrad/models/ReminderModel.dart';
import 'package:firebase_database/firebase_database.dart';

class AwradService {
  final _db = FirebaseDatabase.instance;

  final List<AwradTypesModel> _types = [];
  Future<List<WrdModel>> allAwrad(String wrdType) async {
    final data = await _db.reference().child('$AWRAD/$wrdType').once();
    if (data.value == null) return [];
    final m = Map<String, dynamic>.from(data.value);

    final x =
        m.values.map((e) => WrdModel.fromJson(Map<String, dynamic>.from(e)));

    return x.toList();
  }

  Future<List<AwradTypesModel>> get awradType async {
    try {
      if (_types.isNotEmpty) return _types;
      _types.clear();
      final d = (await _db.reference().child(AWRAD_TYPES).once()).value;
      final m = Map<String, String>.from(d);

      final x = m.keys.map(
        (e) {
          return AwradTypesModel(type: e, typeName: m[e]);
        },
      ).toList();
      _types.addAll(x);
      return _types;
    } catch (e) {
      log(e.toString());
    }
    // _types.clear();
  }

  Future<WrdModel> getWrd(ReminderModel rmd) async {
    final data = (await _db
            .reference()
            .child(AWRAD)
            .child(rmd.type)
            .child(rmd.id)
            .once())
        .value;
    return WrdModel.fromJson(Map<String, String>.from(data));
  }
}
