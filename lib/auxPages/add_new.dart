import 'dart:convert';

import 'package:SimpleWeatherApp/common/languages.dart';
import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:flutter/material.dart';
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
  List<City> searchResults = [];
  getResults(String input, String lang) async {
    var response = await http
        .get(Uri.https('weather.alenygam.com', 'search/geo/$input/$lang'));
    if (response.statusCode >= 300) {
      return;
    }
    var jsonData = jsonDecode(response.body);
    List<City> resultsNew = [];
    for (var u in jsonData) {
      var cityJson = u;
      City city = City(
          cityJson["geonameId"], cityJson["countryName"], cityJson["name"]);
      resultsNew.add(city);
    }
    if (mounted) {
      setState(() {
        searchResults = resultsNew;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String language = Provider.of<SettingsModel>(context).language;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages[language]!.addNew),
      ),
      body: Column(
        children: [
          TextField(
            onSubmitted: (input) {
              getResults(input, language);
            },
            onChanged: (String input) {
              if (input.length % 4 == 0) {
                getResults(input, language);
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (City city in searchResults)
                    ElevatedButton(
                      onPressed: () {
                        widget.addCity(city);
                        Navigator.of(context).pop();
                      },
                      child: Text('${city.name} (${city.country})'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
