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
  var data;

  void getWeatherData() async {
    var response =
        await http.get(Uri.http('192.168.1.12:4000', 'weather/$cityId'));
    if (response.statusCode >= 300) return;
    setState(() {
      data = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    getWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                    const Text(
                      'Condizione Attuale',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  Image.asset('assets/${data["current"]["icon"]}.png'),
                  Text('Temperatura: ${data["current"]["temp"]}°C'),
                  Text('Pressione Atmosferica: ${data["current"]["pressure"]}mBar'),
                  Text('Umidità Relativa: ${data["current"]["humidity"]}%')
                ]),
                Column(children: [
                  Column(children: [
                    for (var forecast in data["hourly"])
                      Row(children: [
                        Column(children: [
                          Image.asset('assets/${forecast["icon"]}.png'),
                        ]),
                        Column(
                          children: [
                            Column(
                              children: [
                                Text('${forecast["temp"].toString()}°C'),
                                Text('${forecast["time"]}'),
                              ],
                            )
                          ],
                        )
                      ])
                  ]),
                ]),
              ],
            ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(var forecast in data["daily"])
                    Column(children: [
                        Image.asset('assets/${forecast["icon"]}.png'),
                        Text(forecast["date"]),
                        const Divider(),
                        Text('Max: ${forecast["hightemp"]}°C'),
                        Text('Low: ${forecast["lowtemp"]}°C'),
                    ],)
                  ],
                ),
            )
          ],
        ),
      ),
    );
  }
}
