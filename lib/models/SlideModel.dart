class SlideModel {
  String desc;
  String img;
  String name;
  String uid;
  num createDate;

  SlideModel({this.desc, this.img, this.name, this.uid});

  SlideModel.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    img = json['img'];
    name = json['name'];
    uid = json['uid'];
    createDate = json['createDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['img'] = this.img;
    data['name'] = this.name;
    data['uid'] = this.uid;
    return data;
  }
}
