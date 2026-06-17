import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class DailyForecast {
  final String dayString;
  final String heroTemp;
  final String heroLabel;
  final String tempRange;
  final String msg;
  final String wind;
  final String windSpeedOnly;
  final String windUnitOnly;
  final String humidity;
  final String aqi;
  final String aqiLabel;
  final String uv;
  final String uvLabel;
  final String sunrise;
  final String sunset;
  final double daylightProgress;
  final String pressure;
  final String visibility;
  final String cloudCover;
  final List<Map<String, String>> hourlyData;

  DailyForecast({
    required this.dayString,
    required this.heroTemp,
    required this.heroLabel,
    required this.tempRange,
    required this.msg,
    required this.wind,
    required this.windSpeedOnly,
    required this.windUnitOnly,
    required this.humidity,
    required this.aqi,
    required this.aqiLabel,
    required this.uv,
    required this.uvLabel,
    required this.sunrise,
    required this.sunset,
    required this.daylightProgress,
    required this.pressure,
    required this.visibility,
    required this.cloudCover,
    required this.hourlyData,
  });
}

class WeatherController extends ChangeNotifier {
  int refreshMinutes = 30;
  bool isLoading = true;
  Timer? _timer;
  SharedPreferences? _prefs;

  List<DailyForecast> forecasts = [];
  String city = "Loading...";
  bool isCelsius = true;
  bool isMetric = true;

  double lati = 0.0;
  double long = 0.0;
  Map<String, dynamic> _rawWeatherCache = {};
  Map<String, dynamic> _rawAqiCache = {};

  final List<String> _weekdays = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
  ];
  final List<String> _months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];

  WeatherController() {
    _initPrefsAndLoad();
    _timer = Timer.periodic(
      Duration(minutes: refreshMinutes),
      (_) => _getLocation(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initPrefsAndLoad() async {
    _prefs = await SharedPreferences.getInstance();
    isCelsius = _prefs?.getBool('isCelsius') ?? true;
    isMetric = _prefs?.getBool('isMetric') ?? true;

    final savedCity = _prefs?.getString('city');
    final savedLati = _prefs?.getDouble('lati');
    final savedLong = _prefs?.getDouble('long');

    if (savedCity != null && savedLati != null && savedLong != null) {
      city = savedCity;
      lati = savedLati;
      long = savedLong;
      notifyListeners();
      await _fetchWeather();
    } else {
      await _getLocation();
    }
  }

  void toggleTempUnit(bool celsius) {
    if (isCelsius == celsius) return;
    isCelsius = celsius;
    _prefs?.setBool('isCelsius', isCelsius);
    if (_rawWeatherCache.isNotEmpty) _formatAllDays();
  }

  void toggleDistanceUnit(bool metric) {
    if (isMetric == metric) return;
    isMetric = metric;
    _prefs?.setBool('isMetric', isMetric);
    if (_rawWeatherCache.isNotEmpty) _formatAllDays();
  }

  double _convertTemp(double tempC) => isCelsius ? tempC : (tempC * 9 / 5) + 32;
  double _convertSpeed(double speedKmh) => isMetric ? speedKmh : speedKmh * 0.621371;

  Future<void> refreshWeather() async {
    await _fetchWeather();
  }

  Future<void> retryGPSLocation() async {
    isLoading = true;
    forecasts = [];
    notifyListeners();

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        isLoading = false;
        notifyListeners();
        return;
      }
      await _getLocation();
    } catch (e) {
      print("Retry failed: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Position> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error("Location services disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }

  Future<void> _getLocation() async {
    try {
      Position currentPosition = await _handleLocationPermission();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      city = placemarks.isNotEmpty
          ? (placemarks[0].locality ?? placemarks[0].name ?? "Unknown")
          : "Unknown";
      lati = currentPosition.latitude;
      long = currentPosition.longitude;

      _prefs?.setString('city', city);
      _prefs?.setDouble('lati', lati);
      _prefs?.setDouble('long', long);

      notifyListeners();
      await _fetchWeather();

    } catch (e) {
      print("Location fetch failed/denied: $e. Prompting manual search.");

      city = "Search City ↗";
      forecasts = [];

      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final url = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json',
      );
      final res = await http.get(url);
      if (res.statusCode == 200) return jsonDecode(res.body)['results'] ?? [];
    } catch (e) {}
    return [];
  }

  Future<void> fetchWeatherForCity(double latitude, double longitude, String cityName) async {
    city = cityName;
    lati = latitude;
    long = longitude;

    _prefs?.setString('city', city);
    _prefs?.setDouble('lati', lati);
    _prefs?.setDouble('long', long);

    notifyListeners();
    await _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final weatherUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lati&longitude=$long'
      '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,surface_pressure,visibility,cloud_cover'
      '&hourly=temperature_2m,precipitation_probability,weather_code,relative_humidity_2m,wind_speed_10m,surface_pressure,visibility,cloud_cover'
      '&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max'
      '&timezone=auto&forecast_days=7',
    );
    final aqiUrl = Uri.parse(
      'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$lati&longitude=$long&current=us_aqi&hourly=us_aqi&timezone=auto&forecast_days=7',
    );

    try {
      final responses = await Future.wait([
        http.get(weatherUrl),
        http.get(aqiUrl),
      ]);
      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        _rawWeatherCache = jsonDecode(responses[0].body);
        _rawAqiCache = jsonDecode(responses[1].body);
        _formatAllDays();
      }
    } catch (e) {}
  }

  DateTime _parseTargetTime(String timeStr) {
    if (timeStr.length == 10) {
      return DateTime.parse("${timeStr}T00:00:00Z");
    }
    return DateTime.parse("${timeStr}Z");
  }

  void _formatAllDays() {
    List<DailyForecast> generatedForecasts = [];

    int offsetSeconds = _rawWeatherCache['utc_offset_seconds'] ?? 0;
    DateTime targetNow = DateTime.now().toUtc().add(Duration(seconds: offsetSeconds));

    for (int i = 0; i < 7; i++) {
      bool isToday = (i == 0);
      int middayIndex = (i * 24) + 12;

      DateTime date = _parseTargetTime(_rawWeatherCache['daily']['time'][i]);
      String dayStr = "${_weekdays[date.weekday - 1]}–${date.day} ${_months[date.month - 1]}.";

      double tempNum = isToday
          ? (_rawWeatherCache["current"]["temperature_2m"] as num).toDouble()
          : (_rawWeatherCache["daily"]["temperature_2m_max"][i] as num).toDouble();

      int humidityNum = isToday
          ? _rawWeatherCache["current"]["relative_humidity_2m"]
          : _rawWeatherCache["hourly"]["relative_humidity_2m"][middayIndex];

      double windNum = isToday
          ? (_rawWeatherCache["current"]["wind_speed_10m"] as num).toDouble()
          : (_rawWeatherCache["hourly"]["wind_speed_10m"][middayIndex] as num).toDouble();

      int codeNum = isToday
          ? _rawWeatherCache["current"]["weather_code"]
          : _rawWeatherCache["hourly"]["weather_code"][middayIndex];

      double pressureNum = isToday
          ? (_rawWeatherCache["current"]["surface_pressure"] as num).toDouble()
          : (_rawWeatherCache["hourly"]["surface_pressure"][middayIndex] as num).toDouble();

      double visNum = isToday
          ? (_rawWeatherCache["current"]["visibility"] as num).toDouble()
          : (_rawWeatherCache["hourly"]["visibility"][middayIndex] as num).toDouble();

      int cloudNum = isToday
          ? _rawWeatherCache["current"]["cloud_cover"]
          : _rawWeatherCache["hourly"]["cloud_cover"][middayIndex];

      int aqiNum = isToday
          ? (_rawAqiCache["current"]["us_aqi"] ?? 0)
          : (_rawAqiCache["hourly"]["us_aqi"][middayIndex] ?? 0);

      double uvNum = (_rawWeatherCache["daily"]["uv_index_max"][i] as num).toDouble();

      double maxT = (_rawWeatherCache["daily"]["temperature_2m_max"][i] as num).toDouble();
      double minT = (_rawWeatherCache["daily"]["temperature_2m_min"][i] as num).toDouble();
      String tRange = "${_convertTemp(maxT).toStringAsFixed(0)}˚ – ${_convertTemp(minT).toStringAsFixed(0)}˚";
      String spdUnit = isMetric ? "km/h" : "mph";

      String windSpeedOnly = _convertSpeed(windNum).toStringAsFixed(0);
      String windUnitOnly = isMetric ? "km/h" : "mph";

      String aLbl = "Good";
      if (aqiNum > 50) aLbl = "Moderate";
      if (aqiNum > 100) aLbl = "Unhealthy for Sensitive";
      if (aqiNum > 150) aLbl = "Unhealthy";
      if (aqiNum > 200) aLbl = "Very Unhealthy";

      String uLbl = "Low";
      if (uvNum >= 3) uLbl = "Moderate";
      if (uvNum >= 6) uLbl = "High";
      if (uvNum >= 8) uLbl = "Very High";
      if (uvNum >= 11) uLbl = "Extreme";

      String srStr = _rawWeatherCache['daily']['sunrise'][i];
      String ssStr = _rawWeatherCache['daily']['sunset'][i];
      double dlProg = -1.0;

      if (isToday && srStr.isNotEmpty && ssStr.isNotEmpty) {
        DateTime sr = _parseTargetTime(srStr);
        DateTime ss = _parseTargetTime(ssStr);
        if (targetNow.isAfter(sr) && targetNow.isBefore(ss)) {
          dlProg = targetNow.difference(sr).inMinutes / ss.difference(sr).inMinutes;
        } else {
          dlProg = -1.0;
        }
      }

      List<Map<String, String>> hourlyList = [];
      List rawTimes = _rawWeatherCache['hourly']['time'];

      int startIndex = i * 24;
      if (isToday) {
        for (int h = 0; h < rawTimes.length; h++) {
          DateTime t = _parseTargetTime(rawTimes[h]);
          if (t.isAfter(targetNow.subtract(const Duration(minutes: 59)))) {
            startIndex = h;
            break;
          }
        }
      }

      for (int h = startIndex; h < startIndex + 24; h++) {
        if (h >= rawTimes.length) break;

        DateTime t = _parseTargetTime(rawTimes[h]);
        int hr = t.hour;
        String ampm = hr >= 12 ? "PM" : "AM";
        hr = hr % 12;
        if (hr == 0) hr = 12;

        hourlyList.add({
          "time": "${hr.toString().padLeft(2, '0')} $ampm",
          "weather": _mapWeatherCode(
            _rawWeatherCache['hourly']['weather_code'][h],
          ),
          "precip": "• ${_rawWeatherCache['hourly']['precipitation_probability'][h]}%",
          "temp": "${_convertTemp((_rawWeatherCache['hourly']['temperature_2m'][h] as num).toDouble()).toStringAsFixed(0)}˚",
        });
      }

      generatedForecasts.add(
        DailyForecast(
          dayString: dayStr,
          heroTemp: "${_convertTemp(tempNum).toStringAsFixed(0)}˚",
          heroLabel: isToday ? "" : "Max",
          tempRange: tRange,
          msg: codeNum >= 50 ? "Yes, It's raining" : "Enjoy your day!",
          wind: "Wind: ${_convertSpeed(windNum).toStringAsFixed(0)}$spdUnit",
          windSpeedOnly: windSpeedOnly,
          windUnitOnly: windUnitOnly,
          humidity: "Humidity: $humidityNum%",
          aqi: aqiNum.toString(),
          aqiLabel: aLbl,
          uv: uvNum.toStringAsFixed(0),
          uvLabel: uLbl,
          sunrise: _formatTime(_parseTargetTime(srStr)),
          sunset: _formatTime(_parseTargetTime(ssStr)),
          daylightProgress: dlProg,
          pressure: isMetric
              ? "${pressureNum.toStringAsFixed(0)} hPa"
              : "${(pressureNum * 0.02953).toStringAsFixed(2)} inHg",
          visibility: isMetric
              ? "${(visNum / 1000).toStringAsFixed(1)} km"
              : "${(visNum / 1609.34).toStringAsFixed(1)} mi",
          cloudCover: "$cloudNum%",
          hourlyData: hourlyList,
        ),
      );
    }

    forecasts = generatedForecasts;
    isLoading = false;
    notifyListeners();
  }

  String _mapWeatherCode(int code) {
    if (code == 0) return "Sunny";
    if (code >= 1 && code <= 3) return "Cloudy";
    if (code >= 45 && code <= 48) return "Foggy";
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return "Rainy";
    return "Cloudy";
  }

  String _formatTime(DateTime time) {
    int h = time.hour;
    String ampm = h >= 12 ? "PM" : "AM";
    h = h % 12;
    if (h == 0) h = 12;
    return "$h:${time.minute.toString().padLeft(2, '0')} $ampm";
  }
}
