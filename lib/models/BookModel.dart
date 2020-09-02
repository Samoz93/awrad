class BookModel {
  String bookAuthor;
  String bookCover;
  String bookLink;
  String bookName;
  String uid;
  num createDate;

  BookModel(
      {this.bookAuthor,
      this.bookCover,
      this.bookLink,
      this.bookName,
      this.uid});

  BookModel.fromJson(Map<String, dynamic> json) {
    bookAuthor = json['bookAuthor'];
    bookCover = json['bookCover'];
    bookLink = json['bookLink'];
    bookName = json['bookName'];
    uid = json['uid'];
    createDate = json['createDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookAuthor'] = this.bookAuthor;
    data['bookCover'] = this.bookCover;
    data['bookLink'] = this.bookLink;
    data['bookName'] = this.bookName;
    data['uid'] = this.uid;
    return data;
  }
}
