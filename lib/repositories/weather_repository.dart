import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherRepository {
  // 1. API Service ka Object
  final WeatherService api;

  // 2. Constructor ke zariye dependency pass ki
  WeatherRepository(this.api);

  // 3. Current Weather fetch karne ke liye
  Future<WeatherModel> getWeather(String city, String unit) async {
    return await api.getWeatherByCity(city, unit);
  }

  // 4. Hourly aur Daily Forecast fetch karne ke liye
  Future<Map<String, dynamic>> getForecast(String city, String unit) async {
    return await api.getForecastByCity(city, unit);
  }
}