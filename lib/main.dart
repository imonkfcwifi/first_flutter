import 'package:flutter/material.dart';

class Player {
  String name = "nico";
  Player({required this.name});
}
// home: ,,, appBar etc)... is named parameter

void main() {
  var nico = Player(name: "nico");
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('hi!!')),
        appBar: AppBar(
          title: Text('hello flutter'),
        ),
      ),
    );
  }
}
