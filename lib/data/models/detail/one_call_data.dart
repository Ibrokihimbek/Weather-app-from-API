import 'package:weather_app/data/models/detail/daily_item/daily_item.dart';
import 'package:weather_app/data/models/detail/hourly_item/hourly_item.dart';

class OneCallData {
  double lat;

  double lon;

  String timezone;

  int timezoneOffset;

  List<HourlyItem> hourly;

  List<DailyItem> daily;

  OneCallData({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.daily,
    required this.hourly,
    required this.timezoneOffset,
  });

  factory OneCallData.fromJson(Map<String, dynamic> json) => OneCallData(
        lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
        lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
        timezone: json['timezone'] as String? ?? '',
        daily: (json['daily'] as List<dynamic>?)
                ?.map((e) => DailyItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        hourly: (json['hourly'] as List<dynamic>?)
                ?.map((e) => HourlyItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        timezoneOffset: json['timezone_offset'] as int? ?? 0,
      );

  @override
  String toString() {
    return '''
     latitude: $lat,
     longitude: $lon
     timezone_offset: $timezoneOffset
     hourly: ${hourly.toString()}
     daily: ${daily.toString()}
    ''';
  }
}
