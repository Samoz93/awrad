import 'dart:convert';

class AwradTypesModel {
  String type;
  String typeName;
  AwradTypesModel({
    this.type,
    this.typeName,
  });

  AwradTypesModel copyWith({
    String type,
    String typeName,
  }) {
    return AwradTypesModel(
      type: type ?? this.type,
      typeName: typeName ?? this.typeName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'typeName': typeName,
    };
  }

  static AwradTypesModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AwradTypesModel(
      type: map['type'],
      typeName: map['typeName'],
    );
  }

  String toJson() => json.encode(toMap());

  static AwradTypesModel fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'AwradTypesModel(type: $type, typeName: $typeName)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AwradTypesModel && o.type == type && o.typeName == typeName;
  }

  @override
  int get hashCode => type.hashCode ^ typeName.hashCode;
}
