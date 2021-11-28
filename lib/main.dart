import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addNew.dart';
import 'weather_info.dart';
import 'weather_info_lat_long.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> cities = [];
  Map<String, WidgetBuilder> routes = {};

  void setRoutes() {
    routes = {
      "/addNewCity": (BuildContext context) => AddNewCity(addNewCity),
    };
    for (String city in cities) {
      routes["/${city.split(';')[1]}"] =
          (BuildContext context) => WeatherInfo(city);
    }
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
      setRoutes();
    });
  }

  void removeCity(String city) async {
    List<String> newCities = List.castFrom(cities);

    newCities.remove(city);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cities', newCities);
    setState(() {
      cities = newCities;
      setRoutes();
    });
  }

  @override
  void initState() {
    _getStoredCities();
    super.initState();
  }

  void _getStoredCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedCities = prefs.getStringList('cities');
    setState(() {
      if (savedCities != null) {
        cities = savedCities;
      }
      setRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: HomePage(cities, removeCity),
      routes: routes,
    );
  }
}

class HomePage extends StatefulWidget {
  final List<String> cities;
  final Function removeCity;
  const HomePage(this.cities, this.removeCity, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void geoLocationWeather() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData _locationData;
    _locationData = await location.getLocation();

    final double latitude = _locationData.latitude!;
    final double longitude = _locationData.longitude!;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WeatherInfoGeo(latitude, longitude)));
  }

  @override
  void initState() {
    geoLocationWeather();
    super.initState();
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
          for (String city in widget.cities)
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/${city.split(";")[1]}');
              },
              onLongPress: () {
                widget.removeCity(city);
              },
              title: Text(city.split(';')[0]),
            ),
          const Divider(),
          ListTile(
            title: const Text("Aggiungi città"),
            trailing: const Icon(Icons.add),
            onTap: () {
              Navigator.of(context).pop();
              // Have to come up with a better solution.
              Navigator.of(context).pushNamed("/addNewCity");
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
        body: Column(
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
              onPressed: geoLocationWeather,
              child: const Text('Prendi posizione GPS'),
            ),
          ],
        )
    );
  }
}
