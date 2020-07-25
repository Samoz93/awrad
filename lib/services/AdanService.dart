import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AdanService {
  final params = CalculationMethod.muslim_world_league.getParameters();

  PrayerTimes getTodayPryers(LocationData location) {
    final myCoordinates = Coordinates(location.latitude,
        location.longitude); // Replace with your own location lat, lng.
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    print(
        "---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr.timeZoneName})---");
    print(DateFormat.jm().format(prayerTimes.fajr));
    print(DateFormat.jm().format(prayerTimes.sunrise));
    print(DateFormat.jm().format(prayerTimes.dhuhr));
    print(DateFormat.jm().format(prayerTimes.asr));
    print(DateFormat.jm().format(prayerTimes.maghrib));
    print(DateFormat.jm().format(prayerTimes.isha));

    print('---');
    return prayerTimes;
    // Custom Timezone Usage. (Most of you won't need this).
    print('NewYork Prayer Times');
    final newYork = Coordinates(35.7750, -78.6336);
    final nyUtcOffset = Duration(hours: -4);
    final nyDate = DateComponents(2015, 7, 12);
    final nyParams = CalculationMethod.north_america.getParameters();
    nyParams.madhab = Madhab.hanafi;
    final nyPrayerTimes =
        PrayerTimes(newYork, nyDate, nyParams, utcOffset: nyUtcOffset);

    print(nyPrayerTimes.fajr.timeZoneName);
    print(DateFormat.jm().format(nyPrayerTimes.fajr));
    print(DateFormat.jm().format(nyPrayerTimes.sunrise));
    print(DateFormat.jm().format(nyPrayerTimes.dhuhr));
    print(DateFormat.jm().format(nyPrayerTimes.asr));
    print(DateFormat.jm().format(nyPrayerTimes.maghrib));
    print(DateFormat.jm().format(nyPrayerTimes.isha));
  }

  // Generate prayer times for one day on April 12th, 2018.
  getNextAzan() {}
}
