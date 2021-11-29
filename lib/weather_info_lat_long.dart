import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    setState(() {
      typeOfScreen = type;
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  var current;
  List<HourlyWeather> hourly = [];
  List<DailyWeather> daily = [];

  Future<void> getWeatherData(double lat, double lon) async {
    var response = await http
        .get(Uri.https('weather.alenygam.com', 'weather/geo/$lat/$lon'));
    if (response.statusCode >= 300) return;
    setState(() {
      setWeathers(jsonDecode(response.body));
    });
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

    Position _locationData = await Geolocator.getCurrentPosition();

    double lat = _locationData.latitude;
    double lon = _locationData.longitude;
    setTypeOfScreen(0);

    await getWeatherData(lat, lon);
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
    late Widget bodyWidget;

    if (typeOfScreen == 0) {
      bodyWidget = const _Loading();
    } else if (typeOfScreen == 1) {
      bodyWidget = NoGPSScreen(geoLocationWeather);
    } else {
      bodyWidget = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _Weather(current, hourly, daily),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Posizione Corrente"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await geoLocationWeather();
        },
        child: bodyWidget,
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitWave(color: Colors.blue, size: 50.0),
    );
  }
}

class _Weather extends StatelessWidget {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;
  const _Weather(this.current, this.hourly, this.daily, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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

class NoGPSScreen extends StatelessWidget {
  final Function geoLocationWeather;
  const NoGPSScreen(this.geoLocationWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Non è stato possibile ricevere la posizione GPS",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'IndieFlower',
            fontSize: 40.0,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            geoLocationWeather();
          },
          child: const Text('Prendi posizione GPS'),
        ),
      ],
    );
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
