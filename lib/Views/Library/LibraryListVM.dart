import 'package:awrad/models/FolderModel.dart';
import 'package:awrad/services/BookService.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class LibraryListVM extends FutureViewModel<List<FolderModel>> {
  final ser = Get.find<BookService>();

  @override
  Future<List<FolderModel>> futureToRun() {
    return ser.folderList;
  }
}
