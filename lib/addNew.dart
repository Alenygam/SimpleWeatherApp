import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        await http.get(Uri.https('weather.alenygam.com', 'search/$input'));
    if (response.statusCode >= 300) {
      return;
    }
    var jsonData = jsonDecode(response.body);
    List<City> resultsNew = [];
    for (var u in jsonData) {
      var cityJson = u["item"];
      City city = City(cityJson["name"], cityJson["country"], cityJson["id"]);
      resultsNew.add(city);
    }
    setState(() {
      searchResults = resultsNew;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
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
          for (City city in searchResults)
            ElevatedButton(
              onPressed: () {
                widget.addCity('${city.name};${city.id};${city.country}');
                Navigator.of(context).pop();
              },
              child: Text('${city.name} (${city.country})')
            ),
        ],
      ),
    );
  }
}

class City {
  final String name, country;
  final num id;
  City(this.name, this.country, this.id);
}
