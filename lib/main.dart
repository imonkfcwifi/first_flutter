import 'package:flutter/material.dart';

void main() {
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
