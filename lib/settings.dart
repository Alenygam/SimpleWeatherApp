import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impostazioni"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Coming Soon...",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'IndieFlower', fontSize: 40.0),
        ),
      ),
    );
  }
}
