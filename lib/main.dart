import 'package:flutter/material.dart';
import 'package:my_weather/data/weather_api_service.dart';
import 'package:my_weather/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => WeatherApiService.create(),
      dispose: (_, WeatherApiService service) => service.client.dispose,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue,
          primarySwatch: Colors.blue,
        ),
        // debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}