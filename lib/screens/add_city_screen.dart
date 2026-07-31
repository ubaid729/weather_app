import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class AddCityScreen extends StatefulWidget {
  const AddCityScreen({super.key});

  @override
  State<AddCityScreen> createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreen> {
  final TextEditingController _cityController = TextEditingController();

  void _searchCity() {
    final cityText = _cityController.text.trim();
    if (cityText.isNotEmpty) {
      // API call to fetch weather for the searched city
      context.read<WeatherProvider>().getWeather(cityText);

      // Go back to the main screens
      Navigator.pop(context); // Close AddCityScreen
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            // Web/Tablet wide screens limitation box
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width > 600 ? 24.0 : 16.0,
                vertical: 12.0,
              ),
              child: Column(
                children: [
                  // ------------------------------------
                  // SEARCH BAR + CANCEL BUTTON ROW
                  // ------------------------------------
                  Row(
                    children: [
                      // Search Field Container
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F7), // Light grey background
                            borderRadius: BorderRadius.circular(25), // Pill shape
                          ),
                          child: TextField(
                            controller: _cityController,
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _searchCity(),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'City name',
                              hintStyle: const TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black38,
                                size: 22,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: Color(0xFF4A72D7),
                                ),
                                onPressed: _searchCity,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Cancel Button
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Close search screen
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF4A72D7),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
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