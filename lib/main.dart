import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottomnav.dart';
import 'addNew.dart';
import 'weather_info.dart';
import 'weather_info_lat_long.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomNav(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> cities = [];
  List<double> latLong = [];

  @override
  void initState() {
    _getStoredCities();
    super.initState();
  }

  void addNewCity(String cityName) async {
    if (cities.contains(cityName)) {
      return;
    }
    List<String> newCities = List.castFrom(cities);
    newCities.add(cityName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cities', newCities);
    setState(() {
      cities = newCities;
    });
  }

  void removeCity(String city) async {
    List<String> newCities = List.castFrom(cities);

    newCities.remove(city);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cities', newCities);
    setState(() {
      cities = newCities;
    });
  }

  void _getStoredCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedCities = prefs.getStringList('cities');
    setState(() {
      if (savedCities != null) {
        cities = savedCities;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meteo"),
        centerTitle: true,
        elevation: 5.0,
      ),
      drawer: Drawer(
          child: ListView(children: <Widget>[
        for (String city in cities)
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WeatherInfo(city)));
            },
            onLongPress: () {
              removeCity(city);
            },
            title: Text(city.split(';')[0]),
          ),
        const Divider(),
        ListTile(
          title: const Text("Aggiungi città"),
          trailing: const Icon(Icons.add),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNewCity(addNewCity)));
          },
        ),
        ListTile(
          title: const Text("Chiudi"),
          trailing: const Icon(Icons.close),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ])),
      body: const WeatherInfoGeo(),
    );
  }
}
