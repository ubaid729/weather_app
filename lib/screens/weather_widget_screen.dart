import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/city_widget_provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/add_city_screen.dart';

class WeatherWidgetScreen extends StatefulWidget {
  const WeatherWidgetScreen({super.key});

  @override
  State<WeatherWidgetScreen> createState() => _WeatherWidgetScreenState();
}

class _WeatherWidgetScreenState extends State<WeatherWidgetScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      // ------------------------------------
      // STEP 1: APPBAR HEADER
      // ------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Weather widget',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleSpacing: 0,
      ),

      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            // Web / Desktop / Tablet Constraint Limit
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: size.width > 600 ? 24.0 : 16.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------------------
                  // STEP 2: DYNAMIC WIDGET PREVIEW CARD
                  // ------------------------------------
                  Consumer2<CityWidgetProvider, WeatherProvider>(
                    builder: (context, cityWidgetProvider, weatherProvider, child) {
                      final selectedCity = cityWidgetProvider.selectedWidgetCity;
                      final isNoneSelected = selectedCity == 'None';

                      // Current dynamic weather values
                      final weather = weatherProvider.weather;
                      final cityName = isNoneSelected
                          ? ''
                          : (weather?.cityName.isNotEmpty == true
                              ? weather!.cityName
                              : selectedCity);
                      final temp =
                          weather != null ? '${weather.temperature.round()}°C' : '--°C';

                      return Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 180),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6B58A8),
                              Color(0xFF20A0B8),
                              Color(0xFF0F1E36),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Side: Time & Date
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: const Text(
                                      '10:28',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Wed, Jul 29 PM',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Right Side: Dynamic Weather Preview
                            if (!isNoneSelected)
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        cityName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            temp,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.nights_stay,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------
                  // STEP 3: AUTOMATIC POSITIONING BANNER
                  // ------------------------------------
                  Consumer<CityWidgetProvider>(
                    builder: (context, provider, child) {
                      if (!provider.isBannerVisible) {
                        return const SizedBox();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Do you want to enable the automatic positioning function for Weather?',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () async {
                                  await provider.toggleAutoLocation(true, context);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF4A72D7)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 0,
                                  ),
                                ),
                                child: provider.isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Enable',
                                        style: TextStyle(
                                          color: Color(0xFF4A72D7),
                                          fontSize: 13,
                                        ),
                                      ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.black26,
                                  size: 18,
                                ),
                                onPressed: () {
                                  provider.closeBanner();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(
                            color: Colors.black12,
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'When the location city is different from the selected city, the weather and time of both cities will be displayed on the widget.',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------
                  // STEP 4: CITY OPTIONS LIST
                  // ------------------------------------
                  Consumer<CityWidgetProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          // Option 1: None
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'None',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: provider.selectedWidgetCity == 'None'
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF4A72D7),
                                  )
                                : null,
                            onTap: () {
                              provider.selectWidgetCity('None');
                            },
                          ),

                          const Divider(height: 1, color: Colors.black12),

                          // Option 2: Sabowal
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Sabowal',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: provider.selectedWidgetCity == 'Sabowal'
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF4A72D7),
                                  )
                                : null,
                            onTap: () {
                              provider.selectWidgetCity('Sabowal');
                            },
                          ),

                          const Divider(height: 1, color: Colors.black12),

                          // Option 3: Other city
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Other city',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4A72D7),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddCityScreen(),
                                ),
                              );
                            },
                          ),
                        ],
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