import 'package:flutter/material.dart';
import 'package:weather/screens/home.dart';

void main() => runApp(const Weather());

class Weather extends StatelessWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      title: "Weather",
      initialRoute: "/",
      routes: {
        "/" : (context) => const Home(),
      },
    );
  }
}