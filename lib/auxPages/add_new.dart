import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:SimpleWeatherApp/common/city.dart';

class AddNewCity extends StatefulWidget {
  final Function addCity;
  const AddNewCity(this.addCity, {Key? key}) : super(key: key);

  @override
  State<AddNewCity> createState() => _AddNewCityState();
}

class _AddNewCityState extends State<AddNewCity> {
  final String title = "Aggiungi una nuova città";

  List<City> searchResults = [];
  getResults(String input) async {
    var response =
        await http.get(Uri.https('weather.alenygam.com', 'search/geo/$input'));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          TextField(
            onSubmitted: getResults,
            onChanged: (String input) {
              if (input.length % 4 == 0) {
                getResults(input);
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Cerca la tua città',
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
