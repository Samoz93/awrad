class QuranReader {
  int code;
  String status;
  List<ReaderData> data;

  QuranReader({this.code, this.status, this.data});

  QuranReader.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<ReaderData>();
      json['data'].forEach((v) {
        data.add(new ReaderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReaderData {
  String identifier;
  String language;
  String name;
  String englishName;
  String format;
  String type;
  Null direction;

  ReaderData(
      {this.identifier,
      this.language,
      this.name,
      this.englishName,
      this.format,
      this.type,
      this.direction});

  ReaderData.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    language = json['language'];
    name = json['name'];
    englishName = json['englishName'];
    format = json['format'];
    type = json['type'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['language'] = this.language;
    data['name'] = this.name;
    data['englishName'] = this.englishName;
    data['format'] = this.format;
    data['type'] = this.type;
    data['direction'] = this.direction;
    return data;
  }
}
