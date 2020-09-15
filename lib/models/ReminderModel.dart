import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/services/DayReminderService.dart';

part 'ReminderModel.g.dart';

@HiveType(typeId: 0)
class ReminderModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  bool isAwrad;
  @HiveField(2)
  String type;
  @HiveField(3)
  String wrdName;
  @HiveField(4)
  String wrdText;
  @HiveField(5)
  int notifId;
  @HiveField(6)
  String link;
  @HiveField(7)
  bool hasSound;
  @HiveField(8)
  List<String> daysNew;
  @HiveField(9)
  bool isPdf;
  @HiveField(10)
  String pdfLink;
  @HiveField(11)
  bool isJuz;
  @HiveField(12)
  int juzPage;
  ReminderModel({
    this.id,
    this.isAwrad,
    this.type,
    this.wrdName,
    this.wrdText,
    this.notifId,
    this.link,
    this.hasSound,
    this.daysNew,
    this.isPdf,
    this.pdfLink,
    this.isJuz,
    this.juzPage,
  });

  int get juzNumber {
    if (isJuz) return int.parse(id.replaceAll("J", ""));
    return -1;
  }

  List<MyWeekDays> get nDay {
    final lst = DayReminderService.convertToListOfList(daysNew);
    final List<MyWeekDays> dayList = [];

    for (var i = 0; i < lst.length; i++) {
      if (lst[i].isNotEmpty) dayList.add(daysOfWeek2[i]);
    }
    return dayList;
  }

  isInToday(int dateWeek) {
    return nDay.where((element) => element.dateWeek == dateWeek).isNotEmpty;
  }

  List<AzanTimeClass> getTimeForDay(int index) {
    final List<String> lst =
        DayReminderService.convertToListOfList(daysNew)[index];
    return lst
        .map((e) =>
            azanTimes.firstWhere((element) => e.trim().contains(element.type)))
        .toList();
  }

  ReminderModel copyWith({
    String id,
    bool isAwrad,
    String type,
    String wrdName,
    String wrdText,
    int notifId,
    String link,
    bool hasSound,
    List<String> daysNew,
    bool isPdf,
    String pdfLink,
    bool isJuz,
    int juzPage,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      isAwrad: isAwrad ?? this.isAwrad,
      type: type ?? this.type,
      wrdName: wrdName ?? this.wrdName,
      wrdText: wrdText ?? this.wrdText,
      notifId: notifId ?? this.notifId,
      link: link ?? this.link,
      hasSound: hasSound ?? this.hasSound,
      daysNew: daysNew ?? this.daysNew,
      isPdf: isPdf ?? this.isPdf,
      pdfLink: pdfLink ?? this.pdfLink,
      isJuz: isJuz ?? this.isJuz,
      juzPage: juzPage ?? this.juzPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isAwrad': isAwrad,
      'type': type,
      'wrdName': wrdName,
      'wrdText': wrdText,
      'notifId': notifId,
      'link': link,
      'hasSound': hasSound,
      'daysNew': daysNew,
      'isPdf': isPdf,
      'pdfLink': pdfLink,
      'isJuz': isJuz,
      'juzPage': juzPage,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReminderModel(
      id: map['id'],
      isAwrad: map['isAwrad'],
      type: map['type'],
      wrdName: map['wrdName'],
      wrdText: map['wrdText'],
      notifId: map['notifId'],
      link: map['link'],
      hasSound: map['hasSound'],
      daysNew: List<String>.from(map['daysNew']),
      isPdf: map['isPdf'],
      pdfLink: map['pdfLink'],
      isJuz: map['isJuz'],
      juzPage: map['juzPage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReminderModel.fromJson(String source) =>
      ReminderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReminderModel(id: $id, isAwrad: $isAwrad, type: $type, wrdName: $wrdName, wrdText: $wrdText, notifId: $notifId, link: $link, hasSound: $hasSound, daysNew: $daysNew, isPdf: $isPdf, pdfLink: $pdfLink, isJuz: $isJuz, juzPage: $juzPage)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ReminderModel &&
        o.id == id &&
        o.isAwrad == isAwrad &&
        o.type == type &&
        o.wrdName == wrdName &&
        o.wrdText == wrdText &&
        o.notifId == notifId &&
        o.link == link &&
        o.hasSound == hasSound &&
        listEquals(o.daysNew, daysNew) &&
        o.isPdf == isPdf &&
        o.pdfLink == pdfLink &&
        o.isJuz == isJuz &&
        o.juzPage == juzPage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isAwrad.hashCode ^
        type.hashCode ^
        wrdName.hashCode ^
        wrdText.hashCode ^
        notifId.hashCode ^
        link.hashCode ^
        hasSound.hashCode ^
        daysNew.hashCode ^
        isPdf.hashCode ^
        pdfLink.hashCode ^
        isJuz.hashCode ^
        juzPage.hashCode;
  }
}
