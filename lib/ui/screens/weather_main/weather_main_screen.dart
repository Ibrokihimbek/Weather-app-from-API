import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:weather_app/data/models/detail/hourly_item/hourly_item.dart';
import 'package:weather_app/data/models/detail/one_call_data.dart';
import 'package:weather_app/ui/widgets/search_delegate_view.dart';
import 'package:weather_app/utils/app_routes.dart';
import 'package:weather_app/utils/images.dart';
import 'package:weather_app/utils/my_utils.dart';
import 'package:weather_app/utils/time_utils.dart';

import '../../../data/models/helper/lat_lon.dart';
import '../../../data/models/weather_main_model.dart';
import '../../../data/repository/app_repository.dart';

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({Key? key}) : super(key: key);

  @override
  State<WeatherMainScreen> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  bool isLoaded = false;
  LatLong? latLong;
  String query = "";
  OneCallData? oneCallData;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData _locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    if (_locationData.latitude != null) {
      setState(() {
        isLoaded = true;
      });
      latLong = LatLong(
        lat: _locationData.latitude!,
        long: _locationData.longitude!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Color.fromARGB(255, 251, 224, 193),
        ),
        elevation: 0,
        leading: InkWell(
          onTap: () async {
            var searchText = await showSearch(
              context: context,
              delegate:
                  SearchDelegateView(suggestionList: MyUtils.getPlaceNames()),
            );
            setState(() {
              query = searchText;
            });
          },
          child: Image.asset(MyImages.image_search),
        ),
        actions: [Image.asset(MyImages.image_drawer)],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFEEACF),
                Color.fromARGB(255, 248, 219, 185),
              ],
            ),
          ),
        ),
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
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (latLong != null)
              FutureBuilder<WeatherMainModel>(
                future: query.isEmpty
                    ? AppRepository.getWeatherMainDataByLocation(
                        latLong: latLong!,
                      )
                    : AppRepository.getWeatherMainDataByQuery(query: query),
                builder: (context, AsyncSnapshot<WeatherMainModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            TimeWeekAndDay.getDateTime(data.dateTime),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            children: [
                              Image.network(
                                "https://openweathermap.org/img/wn/${data.weatherModel[0].icon}@4x.png",
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data.mainInMain.temp.toInt()}",
                                        style: const TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Text(
                                        "°C",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data.weatherModel[0].description,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          RowHolder(MyImages.image_rain_fall, 'RainFall',
                              data.weatherModel[0].description),
                          const SizedBox(
                            height: 5,
                          ),
                          RowHolder(MyImages.image_wind, 'Wind',
                              '${data.windInMain.speed} km/h'),
                          const SizedBox(
                            height: 5,
                          ),
                          RowHolder(MyImages.image_humidity, 'Humidity',
                              '${data.mainInMain.humidity}%'),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text("Error:${snapshot.error.toString()}");
                  }
                },
              ),
            Visibility(
              visible: isLoaded == false,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            if (latLong != null)
              FutureBuilder<OneCallData>(
                  future:
                      AppRepository.getHourlyDailyWeather(latLong: latLong!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (snapshot.hasData) {
                      oneCallData = snapshot.data!;
                      return Column(
                        children: [
                          // Text(
                          //   oneCallData!.timezone,
                          //   style: const TextStyle(
                          //     fontSize: 32,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // Text(
                          //   TimeWeekAndDay.getDateTime(data.dateTime),
                          //   style: const TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          // Row(
                          //   children: [
                          //     Image.network(
                          //       "https://openweathermap.org/img/wn/${oneCallData!.hourly[0].weather[0].icon}@4x.png",
                          //     ),
                          //     const SizedBox(width: 20),
                          //     Column(
                          //       children: [
                          //         Row(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               "${oneCallData!.hourly[0].temp.toInt()}",
                          //               style: const TextStyle(
                          //                 fontSize: 42,
                          //                 fontWeight: FontWeight.w700,
                          //               ),
                          //             ),
                          //             const Text(
                          //               "°C",
                          //               style: TextStyle(
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w400,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         Text(
                          //           oneCallData!.hourly[0].weather[0].description,
                          //           style: const TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w400,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          // RowHolder(MyImages.image_rain_fall, 'RainFall',
                          //    oneCallData!.hourly[0].weather[0].description,),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          // RowHolder(MyImages.image_wind, 'Wind',
                          //     '${oneCallData!.hourly[0].windSpeed} km/h'),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          // RowHolder(MyImages.image_humidity, 'Humidity',
                          //     '${oneCallData!.hourly[0].humidity}%'),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Today',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    'Tomorrow',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFD6996B),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutName.detail,
                                          arguments: oneCallData!.daily);
                                    },
                                    child: const Text(
                                      'Next 7 Days',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFD6996B),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFFD6996B),
                                    size: 16,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            height: 160,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return TimeWeather(oneCallData!.hourly[index]);
                              },
                              itemCount: oneCallData!.hourly.length,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text("Error:${snapshot.error.toString()}");
                    }
                  }),
          ],
        ),
      ),
    );
  }

  Widget RowHolder(String imageName, String word, String word1) {
    return Container(
      padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFCDEC8),
        borderRadius: BorderRadius.circular(18),
      ),
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Image.asset(imageName),
              const SizedBox(
                width: 8,
              ),
              Text(word),
            ],
          ),
          Text(word1),
        ],
      ),
    );
  }

  Widget TimeWeather(HourlyItem times) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFEEAD9),
        borderRadius: BorderRadius.circular(18),
      ),
      width: 100,
      height: 40,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(TimeHour.getDateTime(times.dt)),
          const SizedBox(
            height: 8,
          ),
          Image.network(
            "https://openweathermap.org/img/wn/${times.weather[0].icon}.png",
          ),
          const SizedBox(
            height: 2,
          ),
          Text('${times.temp.toInt()}'),
        ],
      ),
    );
  }
}
