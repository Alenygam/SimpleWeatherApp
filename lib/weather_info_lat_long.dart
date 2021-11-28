import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherInfoGeo extends StatefulWidget {
  final double lat;
  final double lon;
  const WeatherInfoGeo(this.lat, this.lon, {Key? key}) : super(key: key);

  @override
  State<WeatherInfoGeo> createState() => _WeatherInfoGeoState();
}

class _WeatherInfoGeoState extends State<WeatherInfoGeo> {
  double get lat => widget.lat;
  double get lon => widget.lon;
  // ignore: prefer_typing_uninitialized_variables
  var current;
  List<HourlyWeather> hourly = [];
  List<DailyWeather> daily = [];

  void getWeatherData() async {
    var response = await http
        .get(Uri.https('weather.alenygam.com', 'weather/geo/$lat/$lon'));
    if (response.statusCode >= 300) return;
    setState(() {
      setWeathers(jsonDecode(response.body));
    });
  }

  void setWeathers(data) {
    var currentJson = data["current"];
    current = CurrentWeather(
        currentJson["id"],
        currentJson["main"],
        currentJson["description"],
        currentJson["icon"],
        currentJson["temp"],
        currentJson["pressure"],
        currentJson["humidity"]);

    var hourlyJson = data["hourly"];
    for (var forecast in hourlyJson) {
      hourly.add(HourlyWeather(
          forecast["time"],
          forecast["temp"],
          forecast["id"],
          forecast["main"],
          forecast["description"],
          forecast["icon"]));
    }

    var dailyJson = data["daily"];
    for (var forecast in dailyJson) {
      daily.add(DailyWeather(
          forecast["date"],
          forecast["hightemp"],
          forecast["lowtemp"],
          forecast["id"],
          forecast["main"],
          forecast["description"],
          forecast["icon"]));
    }
  }

  @override
  void initState() {
    getWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (current == null) {
      return const Center(
        child: Text(
          'Caricamento...',
          style: TextStyle(
            fontFamily: 'IndieFlower',
            fontSize: 40.0
          )
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CurrentWeatherWidget(current),
          Column(children: [
            for (var forecast in hourly) HourlyWeatherWidget(forecast),
          ]),
        ]),
        const Divider(),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var forecast in daily) DailyWeatherWidget(forecast)
              ],
            )),
      ]),
    );
  }
}

class DailyWeatherWidget extends StatelessWidget {
  final DailyWeather forecast;
  const DailyWeatherWidget(this.forecast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/${forecast.icon}.png'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 19),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(forecast.date,
                    style: const TextStyle(
                      fontSize: 17.5,
                    )),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.device_thermostat, color: Colors.red),
            Text('${forecast.hightemp}°C'),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.device_thermostat, color: Colors.blueGrey),
            Text('${forecast.lowtemp}°C'),
          ],
        ),
      ],
    );
  }
}

class HourlyWeatherWidget extends StatelessWidget {
  final HourlyWeather forecast;
  const HourlyWeatherWidget(this.forecast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(children: [
        Image.asset('assets/${forecast.icon}.png'),
      ]),
      Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const Icon(Icons.device_thermostat, color: Colors.red),
                    Text('${forecast.temp}°C'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const Icon(Icons.access_alarm),
                    Text(forecast.time),
                  ],
                ),
              ),
            ],
          )
        ],
      )
    ]);
  }
}

class CurrentWeatherWidget extends StatelessWidget {
  final CurrentWeather current;
  const CurrentWeatherWidget(this.current, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        'Condizione Attuale',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Image.asset('assets/${current.icon}.png'),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.device_thermostat,
                    size: 40.0, color: Colors.red),
                Text(
                  '${current.temp}°C',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.water, size: 40.0, color: Colors.lightBlue),
                Text(
                  ' ${current.humidity}%',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.5),
                ),
              ],
            ),
          ),
        ],
      ),
      const Divider(),
      Text('Barometro: ${current.pressure}mBar'),
    ]);
  }
}

class CurrentWeather {
  final String main, description, icon;
  final num id, temp, pressure, humidity;
  CurrentWeather(this.id, this.main, this.description, this.icon, this.temp,
      this.pressure, this.humidity);
}

class HourlyWeather {
  final String time, main, description, icon;
  final num temp, id;
  HourlyWeather(
      this.time, this.temp, this.id, this.main, this.description, this.icon);
}

class DailyWeather {
  final String date, main, description, icon;
  final num hightemp, lowtemp, id;
  DailyWeather(this.date, this.hightemp, this.lowtemp, this.id, this.main,
      this.description, this.icon);
}
