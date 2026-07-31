import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/providers/city_widget_provider.dart';

import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/weather_services.dart';

import 'package:weather_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        // Weather Provider
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            WeatherRepository(
              WeatherService(),
            ),
          ),
        ),

        // City Widget Provider
        ChangeNotifierProvider(
          create: (_) => CityWidgetProvider(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}