import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'weather_widget_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Function to show Temperature Unit Selection Dialog
  void _showTemperatureUnitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final screenWidth = MediaQuery.of(dialogContext).size.width;

        return Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ConstrainedBox(
                // Responsive Dialog Width for Web and Mobile
                constraints: BoxConstraints(
                  maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.85,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dialog Title
                      const Text(
                        'Temperature unit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(height: 1, color: Colors.black12),

                      // Option 1: Degrees Celsius °C
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        title: const Text(
                          'Degrees Celsius °C',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        trailing: provider.unit == "metric"
                            ? const Icon(
                                Icons.check,
                                color: Color(0xFF4A72D7),
                              )
                            : null,
                        onTap: () async {
                          await context
                              .read<WeatherProvider>()
                              .updateUnit("metric");
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }
                        },
                      ),

                      const Divider(
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black12,
                      ),

                      // Option 2: Degrees Fahrenheit °F
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        title: const Text(
                          'Degrees Fahrenheit °F',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        trailing: provider.unit == "imperial"
                            ? const Icon(
                                Icons.check,
                                color: Color(0xFF4A72D7),
                              )
                            : null,
                        onTap: () async {
                          await context
                              .read<WeatherProvider>()
                              .updateUnit("imperial");
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

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
          'Settings',
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
            // Web / Desktop par excessive width se bachane ke liye layout constraint
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: size.width > 600 ? 16.0 : 0,
              ),
              children: [
                // Item 1: Home Screen Weather
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 4.0,
                  ),
                  title: const Text(
                    'Home Screen Weather',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.black26,
                    size: 24,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeatherWidgetScreen(),
                      ),
                    );
                  },
                ),

                const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black12,
                ),

                // Item 2: Temperature unit
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 4.0,
                  ),
                  title: const Text(
                    'Temperature unit',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: Consumer<WeatherProvider>(
                    builder: (context, provider, child) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          provider.unit == "metric"
                              ? "Degrees Celsius °C"
                              : "Degrees Fahrenheit °F",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: _showTemperatureUnitDialog,
                ),

                const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black12,
                ),

                // Item 3: Check for update
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 4.0,
                  ),
                  title: const Text(
                    'Check for update',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      'V5.5.1.8',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  onTap: () {
                    // Action for update check
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}