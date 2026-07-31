import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/forecast_model.dart';
import 'package:weather_app/repositories/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository repository;

  WeatherProvider(this.repository);

  WeatherModel? _weather;
  List<HourlyForecast> _hourlyForecast = [];
  List<DailyForecast> _dailyForecast = [];

  String _unit = 'metric';
  bool _isLoading = false;

  // ---------------- Getters ----------------

  WeatherModel? get weather => _weather;
  List<HourlyForecast> get hourlyForecast => _hourlyForecast;
  List<DailyForecast> get dailyForecast => _dailyForecast;
  bool get isLoading => _isLoading;
  String get unit => _unit;

  String get weatherIcon => _weather?.iconCode ?? '';

  String get sunriseTime {
    if (_weather == null || _weather!.sunrise == 0) return '--:--';
    final time = DateTime.fromMillisecondsSinceEpoch(_weather!.sunrise * 1000);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String get sunsetTime {
    if (_weather == null || _weather!.sunset == 0) return '--:--';
    final time = DateTime.fromMillisecondsSinceEpoch(_weather!.sunset * 1000);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // ---------------- Fetch Weather & Forecast ----------------

  Future<void> getWeather(String city) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Current Weather
      _weather = await repository.getWeather(city, _unit);

      // 2. Forecast Data (Hourly + Daily)
      final forecastData = await repository.getForecast(city, _unit);
      _hourlyForecast = forecastData['hourly'] ?? [];
      _dailyForecast = forecastData['daily'] ?? [];
    } catch (e) {
      debugPrint('Weather Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ---------------- Change Unit ----------------

  Future<void> updateUnit(String newUnit) async {
    if (_unit == newUnit) return;
    _unit = newUnit;

    if (_weather != null && _weather!.cityName.isNotEmpty) {
      await getWeather(_weather!.cityName);
    } else {
      notifyListeners();
    }
  }
}