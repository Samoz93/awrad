import 'package:awrad/models/BookModel.dart';
import 'package:awrad/services/BookService.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class LibraryListVM extends FutureViewModel<List<BookModel>> {
  final ser = Get.find<BookService>();

  @override
  Future<List<BookModel>> futureToRun() {
    return ser.bookList;
  }
}
