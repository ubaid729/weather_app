class HourlyForecast {
  final String time;
  final String iconCode;
  final double temp;

  HourlyForecast({
    required this.time,
    required this.iconCode,
    required this.temp,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000);
    String timeStr = '${dt.hour.toString().padLeft(2, '0')}:00';
    return HourlyForecast(
      time: timeStr,
      iconCode: json['weather'][0]['icon'] ?? '',
      temp: (json['main']['temp'] as num).toDouble(),
    );
  }
}

class DailyForecast {
  final String date;
  final String day;
  final String iconCode;
  final double maxTemp;
  final double minTemp;

  DailyForecast({
    required this.date,
    required this.day,
    required this.iconCode,
    required this.maxTemp,
    required this.minTemp,
  });
}