import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:SimpleWeatherApp/common/city.dart';
import 'package:SimpleWeatherApp/common/weather.dart';

class WeatherInfo extends StatefulWidget {
  final City city;
  const WeatherInfo(this.city, {Key? key}) : super(key: key);

  @override
  State<WeatherInfo> createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  String get cityName => widget.city.name;
  num get cityId => widget.city.cityId;
  String get cityCountry => widget.city.country;

  // ignore: prefer_typing_uninitialized_variables
  var current;
  List<HourlyWeather> hourly = [];
  List<DailyWeather> daily = [];

  num typeOfScreen = 0;
  void setTypeOfScreen(num type) {
    if (mounted) {
      setState(() {
        typeOfScreen = type;
      });
    }
  }

  void getWeatherData() async {
    setTypeOfScreen(0);
    hourly = [];
    daily = [];
    var response =
        await http.get(Uri.https('weather.alenygam.com', 'weather/$cityId'));
    if (response.statusCode >= 300) return;
    if (!mounted) return;
    setState(() {
      setWeathers(jsonDecode(response.body));
    });
    setTypeOfScreen(2);
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
    return WeatherPage(getWeatherData, typeOfScreen, current, hourly, daily);
  }
}
