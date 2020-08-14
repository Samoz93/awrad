import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/models/SlideModel.dart';
import 'package:firebase_database/firebase_database.dart';

class SlidesService {
  final _db = FirebaseDatabase.instance;
  List<SlideModel> _slides = [];
  Future<List<SlideModel>> get allSlides async {
    if (_slides.isNotEmpty) return _slides;
    final data = (await _db.reference().child(SLIDES).once()).value;
    if (data == null) return _slides;
    final map = getMap(data);
    final allSlides = map.values.map((e) => SlideModel.fromJson(getMap(e)));
    _slides.addAll(allSlides);
    return _slides;
  }
}
