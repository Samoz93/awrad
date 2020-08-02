import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'ReminderModel.g.dart';

@HiveType(typeId: 0)
class ReminderModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  bool isAwrad;
  @HiveField(2)
  List<int> days;
  @HiveField(3)
  List<int> times;
  @HiveField(4)
  String type;
  @HiveField(5)
  String wrdName;
  @HiveField(6)
  String wrdText;
  @HiveField(7)
  int notifId;
  @HiveField(8)
  String link;
  @HiveField(9)
  bool hasSound;
  ReminderModel({
    this.id,
    this.isAwrad,
    this.days,
    this.times,
    this.type,
    this.wrdName,
    this.wrdText,
    this.notifId,
    this.link,
    this.hasSound,
  });

  bool get hasValidData => days.isNotEmpty && times.isNotEmpty;

  ReminderModel copyWith({
    String id,
    bool isAwrad,
    List<int> days,
    List<int> times,
    String type,
    String wrdName,
    String wrdText,
    int notifId,
    String link,
    bool hasSound,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      isAwrad: isAwrad ?? this.isAwrad,
      days: days ?? this.days,
      times: times ?? this.times,
      type: type ?? this.type,
      wrdName: wrdName ?? this.wrdName,
      wrdText: wrdText ?? this.wrdText,
      notifId: notifId ?? this.notifId,
      link: link ?? this.link,
      hasSound: hasSound ?? this.hasSound,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isAwrad': isAwrad,
      'days': days,
      'times': times,
      'type': type,
      'wrdName': wrdName,
      'wrdText': wrdText,
      'notifId': notifId,
      'link': link,
      'hasSound': hasSound,
    };
  }

  static ReminderModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReminderModel(
      id: map['id'],
      isAwrad: map['isAwrad'],
      days: List<int>.from(map['days']),
      times: List<int>.from(map['times']),
      type: map['type'],
      wrdName: map['wrdName'],
      wrdText: map['wrdText'],
      notifId: map['notifId'],
      link: map['link'],
      hasSound: map['hasSound'],
    );
  }

  String toJson() => json.encode(toMap());

  static ReminderModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReminderModel(id: $id, isAwrad: $isAwrad, days: $days, times: $times, type: $type, wrdName: $wrdName, wrdText: $wrdText, notifId: $notifId, link: $link, hasSound: $hasSound)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ReminderModel &&
        o.id == id &&
        o.isAwrad == isAwrad &&
        listEquals(o.days, days) &&
        listEquals(o.times, times) &&
        o.type == type &&
        o.wrdName == wrdName &&
        o.wrdText == wrdText &&
        o.notifId == notifId &&
        o.link == link &&
        o.hasSound == hasSound;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isAwrad.hashCode ^
        days.hashCode ^
        times.hashCode ^
        type.hashCode ^
        wrdName.hashCode ^
        wrdText.hashCode ^
        notifId.hashCode ^
        link.hashCode ^
        hasSound.hashCode;
  }
}
