# Weather App

Weather App is a Flutter-based mobile application designed to provide accurate, real-time weather updates based on your current location. Built with a clean and modern user interface, the application instantly delivers vital meteorological data, helping you plan your day with confidence.

## How It Works

The application operates by accessing your device's location services to determine your geographical coordinates using the `geolocator` and `geocoding` packages. Once the location is established, it makes an asynchronous HTTP request to the Open-Meteo API to retrieve highly localized current and hourly weather data.

The user interface is broken down into modular components:
- **At Glance:** Displays the current city, date, temperature, daily highs and lows, wind speed, and humidity.
- **Hourly Data:** Provides a 24-hour forecast breakdown, showing time, expected conditions, precipitation probability, and temperature.
- **Detailed Metrics:** Shows additional detailed weather information for the current day.

All data is parsed from JSON and presented using custom typography for a beautiful, readable experience.

## Roadmap

### Current Features
- [x] Automatic location detection
- [x] Real-time current weather data fetching (Open-Meteo API)
- [x] 24-hour hourly weather forecast
- [x] At-a-glance weather summary (High/Low, Wind Speed, Humidity)
- [x] Dynamic messaging based on weather conditions
- [x] Periodic background data refreshing

### Future Features
- [ ] Detailed Metrics for the whole day
- [ ] Scroll down to refresh
- [ ] Weather Data for future days
- [ ] Manually search the location for weather
- [ ] Sliding menu for Settings like Celcius to Fahrenheit, Refresh intervals, etc.
- [ ] Improve Accuracy and overall performance
