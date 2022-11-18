import 'package:flutter/material.dart';
import 'package:weather_app/data/models/detail/daily_item/daily_item.dart';
import 'package:weather_app/ui/screens/weather_detail/weather_detail_screen.dart';
import 'package:weather_app/ui/screens/weather_main/weather_main_screen.dart';

abstract class RoutName {
  static const home = 'home';

  static const detail = 'detail';
}

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutName.home:
        return MaterialPageRoute(builder: (_) => WeatherMainScreen());
      case RoutName.detail:
        return MaterialPageRoute(
          builder: (_) => WeatherDetailScreen(
            daily: settings.arguments as List<DailyItem>,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => Scaffold());
    }
  }
}
