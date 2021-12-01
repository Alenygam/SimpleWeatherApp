import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WeatherPage extends StatelessWidget {
  final Function refresh;
  final num typeOfScreen;
  final CurrentWeather? current;
  final List<HourlyWeather>? hourly;
  final List<DailyWeather>? daily;
  const WeatherPage(this.refresh, this.typeOfScreen, this.current, this.hourly, this.daily, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget bodyWidget;

    if (typeOfScreen == 0) {
      bodyWidget = const _Loading();
    } else if (typeOfScreen == 1) {
      bodyWidget = _NoGPSScreen(refresh);
    } else {
      bodyWidget = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        // Those arguments can never be null, unless you're really trying!
        child: _Weather(current!, hourly!, daily!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Posizione Corrente"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refresh();
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
          _CurrentWeatherWidget(current),
          Column(children: [
            for (var forecast in hourly) _HourlyWeatherWidget(forecast),
          ]),
        ]),
        const Divider(),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var forecast in daily) _DailyWeatherWidget(forecast)
              ],
            )),
      ]),
    );
  }
}

class _DailyWeatherWidget extends StatelessWidget {
  final DailyWeather forecast;
  const _DailyWeatherWidget(this.forecast, {Key? key}) : super(key: key);

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
            const Icon(Icons.device_thermostat, color: Colors.redAccent),
            Text('${forecast.hightemp}°C'),
          ],
        ),
        Row(
          children: [
            Icon(Icons.device_thermostat, color: Colors.indigo[300]),
            Text('${forecast.lowtemp}°C'),
          ],
        ),
      ],
    );
  }
}

class _HourlyWeatherWidget extends StatelessWidget {
  final HourlyWeather forecast;
  const _HourlyWeatherWidget(this.forecast, {Key? key}) : super(key: key);

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
                    const Icon(Icons.device_thermostat, color: Colors.redAccent),
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

class _CurrentWeatherWidget extends StatelessWidget {
  final CurrentWeather current;
  const _CurrentWeatherWidget(this.current, {Key? key}) : super(key: key);

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
                    size: 40.0, color: Colors.redAccent),
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

class _NoGPSScreen extends StatelessWidget {
  final Function geoLocationWeather;
  const _NoGPSScreen(this.geoLocationWeather, {Key? key}) : super(key: key);

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
