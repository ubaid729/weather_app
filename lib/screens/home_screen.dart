import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/city_management_screen.dart';
import 'package:weather_app/screens/setting_screen.dart';
import 'package:weather_app/utils/url_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getWeather('Sabowal');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for dynamic scaling
    final size = MediaQuery.of(context).size;
    final isDesktopOrWeb = size.width > 650;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F3A5D),
              Color(0xFF194A75),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                // Max content width limit for ultra-wide Web displays
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      // ------------------------------------
                      // 1. HEADER SECTION
                      // ------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Consumer<WeatherProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading) {
                                  return const Text(
                                    "Loading...",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                return FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    provider.weather?.cityName.isNotEmpty == true
                                        ? provider.weather!.cityName
                                        : "Sabowal",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.domain,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CityManagementScreen(),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: const Text(
                                            'Share weather',
                                            textAlign: TextAlign.center,
                                          ),
                                          onTap: () => Navigator.pop(context),
                                        ),
                                        const Divider(height: 1),
                                        ListTile(
                                          title: const Text(
                                            'Settings',
                                            textAlign: TextAlign.center,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SettingsScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),

                      // ------------------------------------
                      // 2. MAIN TEMPERATURE & CONDITION
                      // ------------------------------------
                      Consumer<WeatherProvider>(
                        builder: (context, provider, child) {
                          final city =
                              provider.weather?.cityName ?? 'Sabowal';
                          return GestureDetector(
                            onTap: () => openWeatherInBrowser(city),
                            child: Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${provider.weather?.temperature.round() ?? 0}°',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isDesktopOrWeb ? 96 : 80,
                                      fontWeight: FontWeight.w200,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (provider.weatherIcon.isNotEmpty)
                                  Image.network(
                                    'https://openweathermap.org/img/wn/${provider.weatherIcon}@2x.png',
                                    width: isDesktopOrWeb ? 90 : 75,
                                    height: isDesktopOrWeb ? 90 : 75,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const SizedBox(),
                                  ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    provider.weather?.condition ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: size.height * 0.04),

                      // ------------------------------------
                      // 3. HOURLY FORECAST SECTION
                      // ------------------------------------
                      Consumer<WeatherProvider>(
                        builder: (context, provider, child) {
                          if (provider.hourlyForecast.isEmpty) {
                            return const SizedBox();
                          }
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: provider.hourlyForecast.map((item) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isDesktopOrWeb ? 20.0 : 14.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        item.time,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Image.network(
                                        'https://openweathermap.org/img/wn/${item.iconCode}.png',
                                        width: 32,
                                        height: 32,
                                        errorBuilder:
                                            (context, error, stack) =>
                                                const Icon(
                                          Icons.wb_cloudy,
                                          color: Colors.amber,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${item.temp.round()}°C',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: size.height * 0.03),

                      // ------------------------------------
                      // 4. RESPONSIVE FORECAST & DETAILS CARDS
                      // (Desktop par Side-by-Side Row, Mobile par Stacked Column)
                      // ------------------------------------
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 650) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildDailyForecastCard()),
                                const SizedBox(width: 16),
                                Expanded(child: _buildDetailsCard()),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                _buildDailyForecastCard(),
                                const SizedBox(height: 16),
                                _buildDetailsCard(),
                              ],
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'HuaFeng AccuWeather',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '22:12 Publish',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget 1: Daily Forecast Card
  Widget _buildDailyForecastCard() {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.dailyForecast.isEmpty) {
          return const SizedBox();
        }

        final city = provider.weather?.cityName ?? 'Sabowal';

        return GestureDetector(
          onTap: () {
            openWeatherInBrowser('$city 7 day weather forecast');
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            child: Column(
              children: provider.dailyForecast.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Row(
                          children: [
                            Text(
                              item.date,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.day,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.network(
                        'https://openweathermap.org/img/wn/${item.iconCode}.png',
                        width: 26,
                        height: 26,
                        errorBuilder: (context, error, stack) => const Icon(
                          Icons.grain,
                          color: Colors.lightBlueAccent,
                          size: 22,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${item.maxTemp.round()}°',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${item.minTemp.round()}°',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Helper Widget 2: Details Grid Card
  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // Arc Curve + Sunrise / Sunset Times
          SizedBox(
            height: 90,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: SunArcPainter(),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(height: 4),
                      Consumer<WeatherProvider>(
                        builder: (context, provider, child) {
                          return Text(
                            provider.sunriseTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(height: 4),
                      Consumer<WeatherProvider>(
                        builder: (context, provider, child) {
                          return Text(
                            provider.sunsetTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),

          // Dynamic Metrics Grid
          Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              final w = provider.weather;
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      _buildMetricItem(
                        '${w?.feelsLike.round() ?? 0}°',
                        'Feels like',
                      ),
                      _buildMetricItem(
                        '${w?.humidity ?? 0}%',
                        'Humidity',
                      ),
                      _buildMetricItem(
                        '${w?.windSpeed ?? 0} m/s',
                        'SW Wind',
                      ),
                      _buildMetricItem(
                        '${w?.pressure ?? 0} hPa',
                        'Pressure',
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label) {
    return SizedBox(
      width: 75,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class SunArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(20, size.height - 10);
    path.quadraticBezierTo(
      size.width / 2,
      -10,
      size.width - 20,
      size.height - 10,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}