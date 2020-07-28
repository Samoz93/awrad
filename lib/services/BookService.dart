import 'dart:async';
import 'dart:io';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/DATABASECONST.dart';
import 'package:awrad/main.dart';
import 'package:awrad/models/BookModel.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';

class BookService {
  final _db = FirebaseDatabase.instance;
  final dio = Dio();
  final StreamController<double> _progress =
      StreamController<double>.broadcast();
  Stream get progress => _progress.stream;
  bool hasActiveDownload = false;
  Future<List<BookModel>> get bookList async {
    final data = (await _db.reference().child(BOOKS).once()).value;
    final models =
        getMap(data).values.map((e) => BookModel.fromJson(getMap(e))).toList();

    return models;
  }

  Future<String> getBook(BookModel book) async {
    final pth = await _getBookPath(book.uid);
    if (File(pth).existsSync()) {
      _progress.add(1.0);
      return pth;
    }
    if (hasActiveDownload) throw Exception(['يتم الان تحميل كتاب اخر']);
    hasActiveDownload = true;
    await dio.download(
      book.bookLink,
      pth,
      onReceiveProgress: (count, total) => _progress.sink.add(count / total),
    );
    hasActiveDownload = false;
    return pth;
  }

  Future<String> _getBookPath(String uid) async {
    final Directory pth = Platform.isAndroid
        ? await getTemporaryDirectory()
        : await getDownloadsDirectory();
    return "${pth.path}/$uid.pdf";
  }

  Future<void> savePage(String uid, double page) async {
    await mainBox.put(uid, page);
  }

  double getPage(String uid) {
    return mainBox.get(uid, defaultValue: 0.0);
  }
}
