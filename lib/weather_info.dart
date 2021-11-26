import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherInfo extends StatefulWidget {
  final String cityString;
  const WeatherInfo(this.cityString, {Key? key}) : super(key: key);

  @override
  State<WeatherInfo> createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  String get cityName => widget.cityString.split(';')[0];
  String get cityId => widget.cityString.split(';')[1];
  String get cityCountry => widget.cityString.split(';')[2];
  // ignore: prefer_typing_uninitialized_variables
  var current;
  List<HourlyWeather> hourly = [];
  List<DailyWeather> daily = [];

  void getWeatherData() async {
    var response =
        await http.get(Uri.https('weather.alenygam.com', 'weather/$cityId'));
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
      return Scaffold(
        appBar: AppBar(
          title: Text(cityName),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(cityName),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
            Column(children: [
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
                  )
              ),
            ]),
        ),
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
        Text(forecast.date),
        const Divider(),
        Text('Max: ${forecast.hightemp}°C'),
        Text('Low: ${forecast.lowtemp}°C'),
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
            children: [
              Text('${forecast.temp}°C'),
              Text(forecast.time),
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
      Text('Temperatura: ${current.temp}°C'),
      Text('Pressione Atmosferica: ${current.pressure}mBar'),
      Text('Umidità Relativa: ${current.humidity}%')
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
