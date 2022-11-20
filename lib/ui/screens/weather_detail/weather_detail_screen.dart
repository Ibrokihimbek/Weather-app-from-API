import 'package:flutter/material.dart';
import 'package:weather_app/data/models/detail/daily_item/daily_item.dart';
import 'package:weather_app/ui/widgets/custom_appbar.dart';
import 'package:weather_app/utils/images.dart';
import 'package:weather_app/utils/time_utils.dart';

class WeatherDetailScreen extends StatefulWidget {
  final List<DailyItem> daily;
  const WeatherDetailScreen({Key? key, required this.daily}) : super(key: key);

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar(
        title: 'Next 7 Days',
        onSearchTap: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFEEACF),
              Color(0xFFFEBB80),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFEEAD9),
                borderRadius: BorderRadius.circular(15),
              ),
              width: 375,
              height: 235,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TimeWeek.getDateTime(widget.daily[1].dt),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.daily[1].dailyTemp.day.toInt()}°',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Image.network(
                              "https://openweathermap.org/img/wn/${widget.daily[1].weather[0].icon}@2x.png",
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image.asset(MyImages.image_rain_fall),
                            Text(widget.daily[1].weather[0].description),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(MyImages.image_wind),
                            Text('${widget.daily[1].windSpeed} km/h'),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Image.asset(MyImages.image_humidity),
                            ),
                            Text('${widget.daily[1].humidity} %'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            RowHolder(
                Image.network(
                  "https://openweathermap.org/img/wn/${widget.daily[2].weather[0].icon}.png",
                ),
                TimeWeek.getDateTime(widget.daily[2].dt),
                '${widget.daily[2].dailyTemp.day.toInt()}°'),
            const SizedBox(
              height: 5,
            ),
            RowHolder(
                Image.network(
                  "https://openweathermap.org/img/wn/${widget.daily[3].weather[0].icon}.png",
                ),
                TimeWeek.getDateTime(widget.daily[3].dt),
                '${widget.daily[3].dailyTemp.day.toInt()}°'),
            const SizedBox(
              height: 5,
            ),
            RowHolder(
                Image.network(
                  "https://openweathermap.org/img/wn/${widget.daily[4].weather[0].icon}.png",
                ),
                TimeWeek.getDateTime(widget.daily[4].dt),
                '${widget.daily[4].dailyTemp.day.toInt()}°'),
            const SizedBox(
              height: 5,
            ),
            RowHolder(
                Image.network(
                  "https://openweathermap.org/img/wn/${widget.daily[5].weather[0].icon}.png",
                ),
                TimeWeek.getDateTime(widget.daily[5].dt),
                '${widget.daily[5].dailyTemp.day.toInt()}°'),
            const SizedBox(
              height: 5,
            ),
            RowHolder(
                Image.network(
                  "https://openweathermap.org/img/wn/${widget.daily[6].weather[0].icon}.png",
                ),
                TimeWeek.getDateTime(widget.daily[6].dt),
                '${widget.daily[6].dailyTemp.day.toInt()}°'),
            const SizedBox(
              height: 5,
            ),
            RowHolder(
                Image.network(
                  "https://openweathermap.org/img/wn/${widget.daily[7].weather[0].icon}.png",
                ),
                TimeWeek.getDateTime(widget.daily[7].dt),
                '${widget.daily[7].dailyTemp.day.toInt()}°'),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget RowHolder(Image imageName, String word, String word1) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFCDEC8),
        borderRadius: BorderRadius.circular(18),
      ),
      width: 375,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(word),
            Row(
              children: [
                Text(word1),
                const SizedBox(
                  width: 8,
                ),
                imageName,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
