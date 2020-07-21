import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'ReminderModel.g.dart';

@HiveType()
class ReminderModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  bool isAwrad;
  @HiveField(2)
  List<int> days;
  @HiveField(3)
  List<int> times;
  ReminderModel({
    this.id,
    this.isAwrad,
    this.days,
    this.times,
  });

  ReminderModel copyWith({
    String id,
    bool isAwrad,
    List<int> days,
    List<int> times,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      isAwrad: isAwrad ?? this.isAwrad,
      days: days ?? this.days,
      times: times ?? this.times,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isAwrad': isAwrad,
      'days': days,
      'times': times,
    };
  }

  static ReminderModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReminderModel(
      id: map['id'],
      isAwrad: map['isAwrad'],
      days: List<int>.from(map['days']),
      times: List<int>.from(map['times']),
    );
  }

  String toJson() => json.encode(toMap());

  static ReminderModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReminderModel(id: $id, isAwrad: $isAwrad, days: $days, times: $times)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ReminderModel &&
        o.id == id &&
        o.isAwrad == isAwrad &&
        listEquals(o.days, days) &&
        listEquals(o.times, times);
  }

  @override
  int get hashCode {
    return id.hashCode ^ isAwrad.hashCode ^ days.hashCode ^ times.hashCode;
  }
}
