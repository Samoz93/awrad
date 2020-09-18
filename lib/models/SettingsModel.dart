import 'dart:convert';

class SettingMode {
  final bool openShare;
  SettingMode({
    this.openShare,
  });

  SettingMode copyWith({
    bool openShare,
  }) {
    return SettingMode(
      openShare: openShare ?? this.openShare,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'openShare': openShare,
    };
  }

  factory SettingMode.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SettingMode(
      openShare: map['openShare'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingMode.fromJson(String source) =>
      SettingMode.fromMap(json.decode(source));

  @override
  String toString() => 'SettingMode(openShare: $openShare)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SettingMode && o.openShare == openShare;
  }

  @override
  int get hashCode => openShare.hashCode;
}
