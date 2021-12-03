import 'dart:convert';

import 'package:SimpleWeatherApp/common/languages.dart';
import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:SimpleWeatherApp/common/weather.dart';
import 'package:provider/provider.dart';

class WeatherInfoGeo extends StatefulWidget {
  const WeatherInfoGeo({Key? key}) : super(key: key);

  @override
  State<WeatherInfoGeo> createState() => _WeatherInfoGeoState();
}

class _WeatherInfoGeoState extends State<WeatherInfoGeo> {
  // 0: Loading screen
  // 1: No-GPS screen
  // 2: Weather screen
  // This is when first loading the app
  num typeOfScreen = 0;
  void setTypeOfScreen(num type) {
    if (mounted) {
      setState(() {
        typeOfScreen = type;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var current;
  List<HourlyWeather> hourly = [];
  List<DailyWeather> daily = [];

  Future<void> getWeatherData(double lat, double lon) async {
    String units = Provider.of<SettingsModel>(context, listen: false).units;
    var response = await http
        .get(Uri.https('weather.alenygam.com', 'weather/geo/$lat/$lon/$units'));
    if (response.statusCode >= 300) return;
    if (mounted) {
      setState(() {
        setWeathers(jsonDecode(response.body));
      });
    }
  }

  Future<void> geoLocationWeather() async {
    bool _serviceEnabled;
    LocationPermission permission;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Devi abilitare i servizi di geolocalizzazione');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setTypeOfScreen(1);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setTypeOfScreen(1);
      return;
    }

    Position _locationData = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    double lat = _locationData.latitude;
    double lon = _locationData.longitude;
    setTypeOfScreen(0);

    await getWeatherData(lat, lon);
    if (hourly.isNotEmpty && daily.isNotEmpty && current != null)
      setTypeOfScreen(2);
  }

  @override
  void initState() {
    geoLocationWeather();
    super.initState();
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
    hourly = [];
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
    daily = [];
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
  Widget build(BuildContext context) {
    String language = Provider.of<SettingsModel>(context).language;
    return WeatherPage(geoLocationWeather, typeOfScreen, current, hourly, daily,
        languages[language]!.currentPosition);
  }
}
