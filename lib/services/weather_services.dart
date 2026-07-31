import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/forecast_model.dart';

class WeatherService {
  // Base URL
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // API Key
  static const String _apiKey = 'c1ea1bbec48482f7cb8a9f9106497030';

  // 1. Current Weather Fetch Function
  Future<WeatherModel> getWeatherByCity(String cityName, String unit) async {
    final Uri url = Uri.parse(
      '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=$unit',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to load weather data for $cityName');
    }
  }

  // 2. Forecast Fetch Function (Hourly & Daily)
  Future<Map<String, dynamic>> getForecastByCity(String cityName, String unit) async {
    final Uri url = Uri.parse(
      '$_baseUrl/forecast?q=$cityName&appid=$_apiKey&units=$unit',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List list = data['list'];

      // Hourly Forecast (Next 6 slots)
      List<HourlyForecast> hourly = list.take(6).map((item) => HourlyForecast.fromJson(item)).toList();

      // Daily Forecast (Grouping 5 days)
      Map<String, List<dynamic>> daysMap = {};
      for (var item in list) {
        String dateKey = item['dt_txt'].split(' ')[0];
        if (!daysMap.containsKey(dateKey)) {
          daysMap[dateKey] = [];
        }
        daysMap[dateKey]!.add(item);
      }

      List<DailyForecast> daily = [];
      int dayCount = 0;
      daysMap.forEach((date, items) {
        if (dayCount < 5) {
          double max = -100;
          double min = 100;
          String icon = items[0]['weather'][0]['icon'];

          for (var item in items) {
            double tempMax = (item['main']['temp_max'] as num).toDouble();
            double tempMin = (item['main']['temp_min'] as num).toDouble();
            if (tempMax > max) max = tempMax;
            if (tempMin < min) min = tempMin;
          }

          DateTime dt = DateTime.parse(date);
          List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          String dayName = dayCount == 0 ? 'TDY' : (dayCount == 1 ? 'TMR' : weekdays[dt.weekday - 1]);
          String formattedDate = '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';

          daily.add(DailyForecast(
            date: formattedDate,
            day: dayName,
            iconCode: icon,
            maxTemp: max,
            minTemp: min,
          ));
          dayCount++;
        }
      });

      return {'hourly': hourly, 'daily': daily};
    } else {
      throw Exception('Failed to load forecast data for $cityName');
    }
  }
  // Latitude & Longitude se Weather Fetch karne ke liye
Future<WeatherModel> getWeatherByLocation(double lat, double lon, String unit) async {
  final Uri url = Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=$unit');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return WeatherModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load location weather');
  }
}
}