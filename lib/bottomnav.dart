import 'package:SimpleWeatherApp/common/languages.dart';
import 'package:SimpleWeatherApp/common/settings_notifier.dart';
import 'package:flutter/material.dart';

import 'package:SimpleWeatherApp/mainPages/saved_cities.dart';
import 'package:SimpleWeatherApp/mainPages/settings.dart';
import 'package:SimpleWeatherApp/mainPages/weather_info_lat_long.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    String language = Provider.of<SettingsModel>(context).language;

    List<Tab> myTabs = [
      Tab(
        icon: const Icon(Icons.map_outlined),
        child: Text(
          languages[language]!.currentPosition,
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        icon: const Icon(Icons.star),
        child: Text(
          languages[language]!.savedCities,
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        icon: const Icon(Icons.settings),
        child: Text(
          languages[language]!.settings,
          textAlign: TextAlign.center,
        ),
      ),
    ];
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
          labelColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
          controller: tabController,
          tabs: myTabs,
        ),
      ),
    );
  }
}
