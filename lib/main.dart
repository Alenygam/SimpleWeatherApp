import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
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
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const HomePage(),
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
    geoLocationWeather();
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

  void geoLocationWeather() async {
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
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position _locationData = await Geolocator.getCurrentPosition();

    final double latitude = _locationData.latitude;
    final double longitude = _locationData.longitude;

    setState(() {
      latLong = [latitude, longitude];
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
      body: latLong.isEmpty
          ? DefaultHome(geoLocationWeather)
          : WeatherInfoGeo(latLong[0], latLong[1]),
      floatingActionButton:
        latLong.isNotEmpty
        ? FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: geoLocationWeather,
        )
        : null
    );
  }
}

class DefaultHome extends StatelessWidget {
  final Function geoLocationWeather;
  const DefaultHome(this.geoLocationWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Benvenuti nell'applicazione del meteo più semplice che ci sia",
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
