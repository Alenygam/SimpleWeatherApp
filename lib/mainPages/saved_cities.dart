import 'package:SimpleWeatherApp/common/languages.dart';
import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:SimpleWeatherApp/auxPages/add_new.dart';
import 'package:SimpleWeatherApp/auxPages/weather_info.dart';
import 'package:SimpleWeatherApp/common/city.dart';

class SavedCities extends StatefulWidget {
  const SavedCities({Key? key}) : super(key: key);

  @override
  State<SavedCities> createState() => _SavedCitiesState();
}

class _SavedCitiesState extends State<SavedCities> {
  List<City> cities = [];

  @override
  void initState() {
    _getStoredCities();
    super.initState();
  }

  void addNewCity(City city) async {
    if (cities.contains(city)) {
      return;
    }
    List<String> stringCities = [];
    for (City cit in cities) {
      stringCities.add('${cit.name};${cit.cityId};${cit.country}');
    }
    stringCities.add('${city.name};${city.cityId};${city.country}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cities', stringCities);
    if (mounted) {
      setState(() {
        cities.add(city);
      });
    }
  }

  void removeCity(City city) async {
    List<String> stringCities = [];
    for (City cit in cities) {
      if (cit == city) continue;
      stringCities.add('${cit.name};${cit.cityId};${cit.country}');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cities', stringCities);
    if (mounted) {
      setState(() {
        cities.remove(city);
      });
    }
  }

  void _getStoredCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedCities = prefs.getStringList('cities');
    if (!mounted) return;
    setState(() {
      if (savedCities != null) {
        cities = [];
        for (String stringCity in savedCities) {
          City city = City(
            int.parse(stringCity.split(';')[1]),
            stringCity.split(';')[2],
            stringCity.split(';')[0],
          );
          cities.add(city);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String language = Provider.of<SettingsModel>(context).language;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages[language]!.savedCities),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNewCity(addNewCity),
              ));
            },
          ),
        ],
      ),
      body: ListCities(cities, removeCity),
    );
  }
}

class ListCities extends StatelessWidget {
  final List<City> cities;
  final Function removeCity;
  const ListCities(this.cities, this.removeCity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (City city in cities) CityItem(city, removeCity),
      ],
    );
  }
}

class CityItem extends StatelessWidget {
  final City city;
  final Function removeCity;
  const CityItem(this.city, this.removeCity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        removeCity(city);
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (builder) => WeatherInfo(city),
        ));
      },
      title: Text(city.name),
      subtitle: Text(city.country),
      trailing: const Icon(Icons.place_outlined),
    );
  }
}
