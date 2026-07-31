# Weather App

A clean, responsive weather application built with Flutter that provides real-time weather updates, hourly forecasts, and 7-day predictions using the OpenWeather API.

It handles live GPS location detection on mobile and fallback location support on the web, along with dynamic unit conversions and state persistence.

---

## Key Features

* **Real-Time Weather:** Displays current weather details (temperature, condition, humidity, wind speed, pressure, sunrise/sunset times).
* **Live GPS Location:** Automatically fetches weather for your current position using `Geolocator`.
* **City Search & Management:** Search any city globally or manage a list of preferred cities.
* **Unit Conversion:** Easily switch between Celsius (°C) and Fahrenheit (°F) across the app.
* **Forecast Data:** Hourly temperature breakdowns and multi-day forecast trends.
* **State Persistence:** Keeps your settings (chosen city, auto-location status, unit preference) saved locally using `SharedPreferences`.
* **Cross-Platform & Responsive:** Adapted layouts using `MediaQuery` and `LayoutBuilder` for mobile screens, emulators, and web browsers.

---

## Tech Stack & Packages Used

* **Framework:** Flutter (Dart)
* **State Management:** Provider
* **API Integration:** OpenWeather API (`http` package)
* **Location Services:** `geolocator`
* **Local Storage:** `shared_preferences`

---

## How to Run

1. **Clone this repo:**
   ```bash
   git clone [https://github.com/ubaid729/weather_app.git](https://github.com/ubaid729/weather_app.git)
   cd weather_app