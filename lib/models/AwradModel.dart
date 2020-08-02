class WrdModel {
  String uid;
  String wrdDesc;
  String wrdName;
  String wrdType;
  bool hasSound;
  String link;

  WrdModel({this.uid, this.wrdDesc, this.wrdName, this.wrdType});

  WrdModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    wrdDesc = json['wrdDesc'];
    wrdName = json['wrdName'];
    wrdType = json['wrdType'];
    hasSound = json['hasSound'] ?? false;
    link = json['link'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['wrdDesc'] = this.wrdDesc;
    data['wrdName'] = this.wrdName;
    data['wrdType'] = this.wrdType;
    data['hasSound'] = this.hasSound;
    data['link'] = this.hasSound ?? "";

    return data;
  }
}
