import 'package:flutter/material.dart';

import 'package:SimpleWeatherApp/mainPages/saved_cities.dart';
import 'package:SimpleWeatherApp/mainPages/settings.dart';
import 'package:SimpleWeatherApp/mainPages/weather_info_lat_long.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  List<Widget> myChildrens = const [
    WeatherInfoGeo(),
    SavedCities(),
    Settings(),
  ];

  List<Tab> myTabs = const [
    Tab(
      icon: Icon(Icons.map_outlined),
      child: Text(
        'Posizione Corrente',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      icon: Icon(Icons.star),
      child: Text(
        'Città Salvate',
        textAlign: TextAlign.center,
      ),
    ),
    Tab(
      icon: Icon(Icons.settings),
      child: Text(
        'Impostazioni',
        textAlign: TextAlign.center,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: myChildrens,
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 4, color: Colors.blue),
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          controller: tabController,
          tabs: myTabs,
        ),
      ),
    );
  }
}
