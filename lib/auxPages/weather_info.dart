import 'dart:convert';

import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:SimpleWeatherApp/common/city.dart';
import 'package:SimpleWeatherApp/common/weather.dart';
import 'package:provider/provider.dart';

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
  Map<String, List<HourlyWeather>> daily = {};

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
    daily = {};
    String units = Provider.of<SettingsModel>(context, listen: false).units;
    var response = await http
        .get(Uri.https('weather.alenygam.com', 'weather/$cityId/$units'));
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
    for (var date in dailyJson.keys) {
      daily[date] = [];
      for (var hour in dailyJson[date]) {
        daily[date]?.add(HourlyWeather(
            hour["time"],
            hour["temp"],
            hour["id"],
            hour["main"],
            hour["description"],
            hour["icon"]));
      }
    }
  }

  @override
  void initState() {
    getWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherPage(
        getWeatherData, typeOfScreen, current, hourly, daily, cityName);
  }
}
