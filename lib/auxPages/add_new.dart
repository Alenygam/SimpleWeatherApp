import 'dart:async';
import 'dart:convert';

import 'package:SimpleWeatherApp/common/languages.dart';
import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import 'package:SimpleWeatherApp/common/city.dart';
import 'package:provider/provider.dart';

class AddNewCity extends StatefulWidget {
  final Function addCity;
  const AddNewCity(this.addCity, {Key? key}) : super(key: key);

  @override
  State<AddNewCity> createState() => _AddNewCityState();
}

class _AddNewCityState extends State<AddNewCity> {
  Future<List<City>> getResults(String input, String lang) async {
    var response = await http
        .get(Uri.https('weather.alenygam.com', 'search/geo/$input/$lang'));
    if (response.statusCode >= 300) {
      return <City> [];
    }
    var jsonData = jsonDecode(response.body);
    List<City> results = [];
    for (var u in jsonData) {
      var cityJson = u;
      City city = City(
          cityJson["geonameId"], cityJson["countryName"], cityJson["name"]);
      results.add(city);
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    String language = Provider.of<SettingsModel>(context).language;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages[language]!.addNew),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TypeAheadField<City>(
          textFieldConfiguration: const TextFieldConfiguration(
            autofocus: true,
          ),
          suggestionsCallback: (pattern) async {
            return await getResults(pattern, language);
          },
          itemBuilder: (context, City suggestion) {
            return ListTile(
              title: Text(suggestion.name),
              subtitle: Text(suggestion.country),
              leading: const Icon(Icons.place_outlined),
            );
          },
          onSuggestionSelected: (City city) {
            widget.addCity(city);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
