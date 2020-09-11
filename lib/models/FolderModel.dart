import 'package:awrad/Consts/ConstMethodes.dart';

class FolderModel {
  String author;
  dynamic books;
  int createDate;
  String link;
  String name;
  String path;
  String uid;

  List<FBookModel> get fbooks {
    if (books == null) return [];
    final map = getMap(books);
    return map.values.map((e) => FBookModel.fromJson(getMap(e))).toList();
  }

  FolderModel(
      {this.author,
      this.books,
      this.createDate,
      this.link,
      this.name,
      this.path,
      this.uid});

  FolderModel.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    books = json['books'];
    createDate = json['createDate'];
    link = json['link'];
    name = json['name'];
    path = json['path'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    if (this.books != null) {
      data['books'] = this.books.toJson();
    }
    data['createDate'] = this.createDate;
    data['link'] = this.link;
    data['name'] = this.name;
    data['path'] = this.path;
    data['uid'] = this.uid;
    return data;
  }
}

class FBookModel {
  String bookLink;
  String bookPath;
  int createDate;
  String imageLink;
  String imagePath;
  String name;
  String uid;

  FBookModel(
      {this.bookLink,
      this.bookPath,
      this.createDate,
      this.imageLink,
      this.imagePath,
      this.name,
      this.uid});

  FBookModel.fromJson(Map<String, dynamic> json) {
    bookLink = json['bookLink'];
    bookPath = json['bookPath'];
    createDate = json['createDate'];
    imageLink = json['imageLink'];
    imagePath = json['imagePath'];
    name = json['name'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookLink'] = this.bookLink;
    data['bookPath'] = this.bookPath;
    data['createDate'] = this.createDate;
    data['imageLink'] = this.imageLink;
    data['imagePath'] = this.imagePath;
    data['name'] = this.name;
    data['uid'] = this.uid;
    return data;
  }
}
