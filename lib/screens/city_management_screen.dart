import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/city_widget_provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/add_city_screen.dart';

class CityManagementScreen extends StatefulWidget {
  const CityManagementScreen({super.key});

  @override
  State<CityManagementScreen> createState() => _CityManagementScreenState();
}

class _CityManagementScreenState extends State<CityManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'City management',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCityScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            // Web / Wide screens scaling limit
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: size.width > 600 ? 24.0 : 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  // ------------------------------------
                  // 1. AUTO-LOCATION TOGGLE ROW
                  // ------------------------------------
                  Consumer<CityWidgetProvider>(
                    builder: (context, cityProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Auto-location',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          cityProvider.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Switch(
                                  value: cityProvider.isAutoLocationEnabled,
                                  activeThumbColor: Colors.blueAccent,
                                  inactiveTrackColor: Colors.black12,
                                  onChanged: (value) {
                                    cityProvider.toggleAutoLocation(
                                      value,
                                      context,
                                    );
                                  },
                                ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // ------------------------------------
                  // 2. DYNAMIC CITY WEATHER CARD
                  // ------------------------------------
                  Consumer<WeatherProvider>(
                    builder: (context, weatherProvider, child) {
                      final weather = weatherProvider.weather;
                      final cityName = weather?.cityName.isNotEmpty == true
                          ? weather!.cityName
                          : 'Sabowal';
                      final temp = weather != null
                          ? '${weather.temperature.round()}°C'
                          : '--°C';

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 22.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF144670),
                                  Color(0xFF194A75),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    cityName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        temp,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.menu,
                                      color: Colors.white70,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}