import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/weather_provider.dart';

class CityWidgetProvider extends ChangeNotifier {
  String _selectedWidgetCity = "Sabowal";
  bool _isAutoLocationEnabled = false;
  bool _isBannerVisible = true;
  bool _isLoading = false;

  // SharedPreferences Keys
  static const String _keyCity = "selected_widget_city";
  static const String _keyAutoLocation = "is_auto_location_enabled";

  CityWidgetProvider() {
    _loadPreferences(); // App start hote hi saved state load karein
  }

  // Getters
  String get selectedWidgetCity => _selectedWidgetCity;
  bool get isAutoLocationEnabled => _isAutoLocationEnabled;
  bool get isBannerVisible => _isBannerVisible;
  bool get isLoading => _isLoading;

  // 1. Load Saved Settings on App Startup
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedWidgetCity = prefs.getString(_keyCity) ?? "Sabowal";
    _isAutoLocationEnabled = prefs.getBool(_keyAutoLocation) ?? false;
    notifyListeners();
  }

  // 2. Select City & Save to SharedPreferences
  Future<void> selectWidgetCity(String city) async {
    _selectedWidgetCity = city;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCity, city);
  }

  // 3. Toggle Auto Location & Save State
  Future<void> toggleAutoLocation(bool value, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    if (value) {
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            _isLoading = false;
            _isAutoLocationEnabled = false;
            await prefs.setBool(_keyAutoLocation, false);
            notifyListeners();
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          _isLoading = false;
          _isAutoLocationEnabled = false;
          await prefs.setBool(_keyAutoLocation, false);
          notifyListeners();
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 8),
          ),
        );

        if (context.mounted) {
          final weatherProvider = context.read<WeatherProvider>();
          final weather = await weatherProvider.repository.api.getWeatherByLocation(
            position.latitude,
            position.longitude,
            weatherProvider.unit,
          );

          await weatherProvider.getWeather(weather.cityName);
          _selectedWidgetCity = weather.cityName;
          await prefs.setString(_keyCity, weather.cityName);
        }

        _isAutoLocationEnabled = true;
        await prefs.setBool(_keyAutoLocation, true);
      } catch (e) {
        debugPrint("Auto Location Error: $e");
        _isAutoLocationEnabled = false;
        await prefs.setBool(_keyAutoLocation, false);
      }
    } else {
      _isAutoLocationEnabled = false;
      await prefs.setBool(_keyAutoLocation, false);
    }

    _isLoading = false;
    notifyListeners();
  }

  void closeBanner() {
    _isBannerVisible = false;
    notifyListeners();
  }
}