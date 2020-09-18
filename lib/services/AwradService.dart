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
    final data = await _db
        .reference()
        .child('$AWRAD/$wrdType')
        .orderByChild("createDate")
        .once();
    if (data.value == null) return [];
    final m = Map<String, dynamic>.from(data.value);

    final x =
        m.values.map((e) => WrdModel.fromJson(Map<String, dynamic>.from(e)));

    return x.toList()..sort(_sort);
  }

  int _sort(WrdModel cr, WrdModel cr2) {
    if (cr.createDate == null) return 0;
    return cr.createDate.compareTo(cr2.createDate);
  }

  Future<List<AwradTypesModel>> get awradType async {
    try {
      if (_types.isNotEmpty) return _types;
      _types.clear();
      final d = (await _db.reference().child(AWRAD_TYPES).once()).value;
      final sorting =
          (await _db.reference().child(AWRAD_TYPES_Sorting).once()).value;

      final m = Map<String, String>.from(d);

      final x = m.keys.map(
        (e) {
          return AwradTypesModel(type: e, typeName: m[e]);
        },
      ).toList();
      _types.addAll(x);
      return _types
        ..sort((a, b) {
          final aS = sorting[a.type] ?? 0;
          final bS = sorting[b.type] ?? 0;

          return aS - bS;
        });
    } catch (e) {
      log(e.toString());
      return [];
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

  reportMissingWrd(WrdModel wrd) {
    _db.reference().child(MissingWrd).child(wrd.uid).update(wrd.toJson());
  }
}
