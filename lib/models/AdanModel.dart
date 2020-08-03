import 'dart:developer';

import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:intl/intl.dart';

class AdanModel {
  int code;
  String status;
  List<AdanData> data;

  AdanModel({this.code, this.status, this.data});

  AdanModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<AdanData>();
      json['data'].forEach((v) {
        data.add(new AdanData.fromJson(v));
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

  AdanData getAdan(DateTime date) {
    final day = date.day;
    final timing =
        data.firstWhere((e) => int.parse(e.date.gregorian.day) == day);

    return timing;
  }

  AdanData get todayAdan {
    return getAdan(DateTime.now());
  }
}

class AdanData {
  Timings timings;
  Date date;
  Meta meta;

  AdanData({this.timings, this.date, this.meta});

  AdanData.fromJson(Map<String, dynamic> json) {
    timings =
        json['timings'] != null ? new Timings.fromJson(json['timings']) : null;
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timings != null) {
      data['timings'] = this.timings.toJson();
    }
    if (this.date != null) {
      data['date'] = this.date.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }

  DateTime getDateByType(String type) {
    final year = int.parse(date.gregorian.year);
    final day = int.parse(date.gregorian.day);
    final now = DateTime(year, date.gregorian.month.number, day);
    final tim = timings.getTiming(type);
    final utcHour = tim.substring(0, 2);
    final utcMinutes =
        tim.substring(tim.indexOf(":") + 1, tim.indexOf(":") + 3);

    final dt = DateTime(now.year, now.month, now.day, int.parse(utcHour),
        int.parse(utcMinutes));
    return dt;
  }
}

class Timings {
  String fajr;
  String sunrise;
  String dhuhr;
  String asr;
  String sunset;
  String maghrib;
  String isha;
  String imsak;
  String midnight;

  Timings(
      {this.fajr,
      this.sunrise,
      this.dhuhr,
      this.asr,
      this.sunset,
      this.maghrib,
      this.isha,
      this.imsak,
      this.midnight});

  Timings.fromJson(Map<String, dynamic> json) {
    fajr = json['Fajr'];
    sunrise = json['Sunrise'];
    dhuhr = json['Dhuhr'];
    asr = json['Asr'];
    sunset = json['Sunset'];
    maghrib = json['Maghrib'];
    isha = json['Isha'];
    imsak = json['Imsak'];
    midnight = json['Midnight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Fajr'] = this.fajr;
    data['Sunrise'] = this.sunrise;
    data['Dhuhr'] = this.dhuhr;
    data['Asr'] = this.asr;
    data['Sunset'] = this.sunset;
    data['Maghrib'] = this.maghrib;
    data['Isha'] = this.isha;
    data['Imsak'] = this.imsak;
    data['Midnight'] = this.midnight;
    return data;
  }

  String getTiming(String timing) {
    switch (timing) {
      case "Fajr":
        return fajr;
      case "Sunrise":
        return sunrise;
      case "Dhuhr":
        return dhuhr;
      case "Asr":
        return asr;
      case "Maghrib":
        return maghrib;
      case "Isha":
        return isha;
      case "Midnight":
        return midnight;
      default:
        return "un";
    }
  }

  getTIimingLocalString(String timing) {
    try {
      return DateFormat.jm("ar").format(getTimingDateTime(timing));
    } catch (e) {
      log(e.toString());
    }
  }

  DateTime getTimingDateTime(String timing) {
    try {
      final tim = getTiming(timing);
      final utcHour = tim.substring(0, 2);
      final utcMinutes =
          tim.substring(tim.indexOf(":") + 1, tim.indexOf(":") + 3);

      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, int.parse(utcHour),
          int.parse(utcMinutes));
      return dt;
    } catch (e) {
      return DateTime.now();
    }
  }

  AzanTimeClass get nexAdanTime {
    AzanTimeClass time = azanTimes[0];
    for (var t in azanTimes) {
      if (getTimingDateTime(t.type).isAfter(DateTime.now())) {
        time = t;
        break;
      }
    }
    return time;
  }
}

class Date {
  String readable;
  String timestamp;
  Gregorian gregorian;
  Hijri hijri;

  Date({this.readable, this.timestamp, this.gregorian, this.hijri});

  Date.fromJson(Map<String, dynamic> json) {
    readable = json['readable'];
    timestamp = json['timestamp'];
    gregorian = json['gregorian'] != null
        ? new Gregorian.fromJson(json['gregorian'])
        : null;
    hijri = json['hijri'] != null ? new Hijri.fromJson(json['hijri']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readable'] = this.readable;
    data['timestamp'] = this.timestamp;
    if (this.gregorian != null) {
      data['gregorian'] = this.gregorian.toJson();
    }
    if (this.hijri != null) {
      data['hijri'] = this.hijri.toJson();
    }
    return data;
  }
}

class Gregorian {
  String date;
  String format;
  String day;
  NormalWeekday weekday;
  NormalMonth month;
  String year;
  Designation designation;

  Gregorian(
      {this.date,
      this.format,
      this.day,
      this.weekday,
      this.month,
      this.year,
      this.designation});

  Gregorian.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday = json['weekday'] != null
        ? new NormalWeekday.fromJson(json['weekday'])
        : null;
    month =
        json['month'] != null ? new NormalMonth.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null
        ? new Designation.fromJson(json['designation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['format'] = this.format;
    data['day'] = this.day;
    if (this.weekday != null) {
      data['weekday'] = this.weekday.toJson();
    }
    if (this.month != null) {
      data['month'] = this.month.toJson();
    }
    data['year'] = this.year;
    if (this.designation != null) {
      data['designation'] = this.designation.toJson();
    }
    return data;
  }
}

class NormalWeekday {
  String en;

  NormalWeekday({this.en});

  NormalWeekday.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

class NormalMonth {
  int number;
  String en;

  NormalMonth({this.number, this.en});

  NormalMonth.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['en'] = this.en;
    return data;
  }
}

class Designation {
  String abbreviated;
  String expanded;

  Designation({this.abbreviated, this.expanded});

  Designation.fromJson(Map<String, dynamic> json) {
    abbreviated = json['abbreviated'];
    expanded = json['expanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abbreviated'] = this.abbreviated;
    data['expanded'] = this.expanded;
    return data;
  }
}

class Hijri {
  String date;
  String format;
  String day;
  HijriWeekday weekday;
  HijriMonth month;
  String year;
  Designation designation;
  List<String> holidays;

  Hijri(
      {this.date,
      this.format,
      this.day,
      this.weekday,
      this.month,
      this.year,
      this.designation,
      this.holidays});

  Hijri.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday = json['weekday'] != null
        ? new HijriWeekday.fromJson(json['weekday'])
        : null;
    month =
        json['month'] != null ? new HijriMonth.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null
        ? new Designation.fromJson(json['designation'])
        : null;
    holidays = json['holidays'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['format'] = this.format;
    data['day'] = this.day;
    if (this.weekday != null) {
      data['weekday'] = this.weekday.toJson();
    }
    if (this.month != null) {
      data['month'] = this.month.toJson();
    }
    data['year'] = this.year;
    if (this.designation != null) {
      data['designation'] = this.designation.toJson();
    }
    data['holidays'] = this.holidays;
    return data;
  }

  String get formattedDate {
    return "${month.ar} $year/${month.number}/$day";
  }
}

class HijriWeekday {
  String en;
  String ar;

  HijriWeekday({this.en, this.ar});

  HijriWeekday.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

class HijriMonth {
  int number;
  String en;
  String ar;

  HijriMonth({this.number, this.en, this.ar});

  HijriMonth.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

class Meta {
  double latitude;
  double longitude;
  String timezone;
  Method method;
  String latitudeAdjustmentMethod;
  String midnightMode;
  String school;
  Offset offset;

  Meta(
      {this.latitude,
      this.longitude,
      this.timezone,
      this.method,
      this.latitudeAdjustmentMethod,
      this.midnightMode,
      this.school,
      this.offset});

  Meta.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    timezone = json['timezone'];
    method =
        json['method'] != null ? new Method.fromJson(json['method']) : null;
    latitudeAdjustmentMethod = json['latitudeAdjustmentMethod'];
    midnightMode = json['midnightMode'];
    school = json['school'];
    offset =
        json['offset'] != null ? new Offset.fromJson(json['offset']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['timezone'] = this.timezone;
    if (this.method != null) {
      data['method'] = this.method.toJson();
    }
    data['latitudeAdjustmentMethod'] = this.latitudeAdjustmentMethod;
    data['midnightMode'] = this.midnightMode;
    data['school'] = this.school;
    if (this.offset != null) {
      data['offset'] = this.offset.toJson();
    }
    return data;
  }
}

class Method {
  int id;
  String name;
  Params params;

  Method({this.id, this.name, this.params});

  Method.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    params =
        json['params'] != null ? new Params.fromJson(json['params']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.params != null) {
      data['params'] = this.params.toJson();
    }
    return data;
  }
}

class Params {
  int fajr;
  int isha;

  Params({this.fajr, this.isha});

  Params.fromJson(Map<String, dynamic> json) {
    fajr = json['Fajr'];
    isha = json['Isha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Fajr'] = this.fajr;
    data['Isha'] = this.isha;
    return data;
  }
}

class Offset {
  int imsak;
  int fajr;
  int sunrise;
  int dhuhr;
  int asr;
  int maghrib;
  int sunset;
  int isha;
  int midnight;

  Offset(
      {this.imsak,
      this.fajr,
      this.sunrise,
      this.dhuhr,
      this.asr,
      this.maghrib,
      this.sunset,
      this.isha,
      this.midnight});

  Offset.fromJson(Map<String, dynamic> json) {
    imsak = json['Imsak'];
    fajr = json['Fajr'];
    sunrise = json['Sunrise'];
    dhuhr = json['Dhuhr'];
    asr = json['Asr'];
    maghrib = json['Maghrib'];
    sunset = json['Sunset'];
    isha = json['Isha'];
    midnight = json['Midnight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Imsak'] = this.imsak;
    data['Fajr'] = this.fajr;
    data['Sunrise'] = this.sunrise;
    data['Dhuhr'] = this.dhuhr;
    data['Asr'] = this.asr;
    data['Maghrib'] = this.maghrib;
    data['Sunset'] = this.sunset;
    data['Isha'] = this.isha;
    data['Midnight'] = this.midnight;
    return data;
  }
}
