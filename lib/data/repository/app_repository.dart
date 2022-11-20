import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:weather_app/data/models/detail/one_call_data.dart';
import 'package:weather_app/data/models/helper/lat_lon.dart';
import 'package:weather_app/data/models/weather_main_model.dart';

const String BASE_URL = "api.openweathermap.org";
const String API_TOKEN = "4a8eaf9ed512f638cdd7a82434895402";

class AppRepository {
  static Future<WeatherMainModel> getWeatherMainDataByQuery({
    required String query,
  }) async {
    var queryParams = {
      "appid": API_TOKEN,
      "q": query,
      "units": "metric",
    };
    var uri = Uri.https(BASE_URL, "/data/2.5/weather", queryParams);
    try {
      Response response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return WeatherMainModel.fromJson(jsonDecode(response.body));
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  static Future<WeatherMainModel> getWeatherMainDataByLocation(
      {required LatLong latLong}) async {
    var queryParams = {
      "lat": latLong.lat.toString(),
      "lon": latLong.long.toString(),
      "appid": API_TOKEN,
      "units": "metric",
    };
    var uri = Uri.https(BASE_URL, "/data/2.5/weather", queryParams);
    try {
      Response response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return WeatherMainModel.fromJson(jsonDecode(response.body));
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  static Future<OneCallData> getHourlyDailyWeather(
      {required LatLong latLong}) async {
    var queryParams = {
      "lat": latLong.lat.toString(),
      "lon": latLong.long.toString(),
      "units": "metric",
      "exclude": "minutely,current",
      "appid": API_TOKEN,
    };
    var uri = Uri.https(BASE_URL, "/data/2.5/onecall", queryParams);

    try {
      Response response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return OneCallData.fromJson(jsonDecode(response.body));
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
