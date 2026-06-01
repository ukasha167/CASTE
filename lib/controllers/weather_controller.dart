import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class WeatherController extends ChangeNotifier {
  int refreshMinutes = 30;
  Timer? _timer;
  SharedPreferences? _prefs;

  String city = "Loading...";
  String day = "Unknown Day";
  String temp = "--˚";
  String tempRange = "--˚ – --˚";
  String msg = "Unknown";
  String wind = "Wind: --km/h";
  String humidity = "Humidity: --%";
  List<Map<String, String>> hourlyData = [];

  double _rawCurrentTempC = 0.0;
  double _rawWindKmh = 0.0;
  int _rawHumidity = 0;
  int _rawConditionCode = 0;
  double _rawMaxTempC = 0.0;
  double _rawMinTempC = 0.0;
  List<dynamic> _rawHourlyTimes = [];
  List<dynamic> _rawHourlyTempsC = [];
  List<dynamic> _rawHourlyPrecip = [];
  List<dynamic> _rawHourlyCodes = [];

  bool isCelsius = true;
  bool isMetric = true;

  Position? position;
  double lati = 0.0;
  double long = 0.0;

  final List<String> _weekdays = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
  ];
  final List<String> _months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];

  WeatherController() {
    day = _getDay();
    _initPrefsAndLoad();

    _timer = Timer.periodic(Duration(minutes: refreshMinutes), (timer) {
      _getLocation();
    });
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

    await _getLocation();
  }

  void toggleTempUnit(bool celsius) {
    if (isCelsius == celsius) return;
    isCelsius = celsius;
    _prefs?.setBool('isCelsius', isCelsius);

    _formatWeatherData();
  }

  void toggleDistanceUnit(bool metric) {
    if (isMetric == metric) return;
    isMetric = metric;
    _prefs?.setBool('isMetric', isMetric);

    _formatWeatherData();
  }

  double _convertTemp(double tempC) {
    return isCelsius ? tempC : (tempC * 9 / 5) + 32;
  }

  double _convertSpeed(double speedKmh) {
    return isMetric ? speedKmh : speedKmh * 0.621371;
  }

  String _getDay() {
    final DateTime now = DateTime.now();
    return "${_weekdays[now.weekday - 1]}–${now.day} ${_months[now.month - 1]}.";
  }

  void _formatWeatherData() {
    temp = "${_convertTemp(_rawCurrentTempC).toStringAsFixed(0)}˚";
    tempRange = "${_convertTemp(_rawMaxTempC).toStringAsFixed(0)}˚ – ${_convertTemp(_rawMinTempC).toStringAsFixed(0)}˚";

    final speedUnit = isMetric ? "km/h" : "mph";
    wind = "Wind: ${_convertSpeed(_rawWindKmh).toStringAsFixed(0)}$speedUnit";
    humidity = "Humidity: $_rawHumidity%";
    msg = _rawConditionCode >= 50 ? "Yes, It's raining" : "Enjoy your day!";

    List<Map<String, String>> freshHourlyList = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < _rawHourlyTimes.length; i++) {
      DateTime parsedTime = DateTime.parse(_rawHourlyTimes[i]);
      if (parsedTime.isBefore(now.subtract(const Duration(minutes: 59)))) continue;

      int hourNum = parsedTime.hour;
      String amPm = hourNum >= 12 ? "Pm" : "Am";
      int displayHour = hourNum % 12 == 0 ? 12 : hourNum % 12;

      freshHourlyList.add({
        "time": "${displayHour.toString().padLeft(2, '0')} $amPm",
        "weather": _mapWeatherCode(_rawHourlyCodes[i]),
        "precip": "• ${_rawHourlyPrecip[i]}%",
        "temp": "${_convertTemp((_rawHourlyTempsC[i] as num).toDouble()).toStringAsFixed(0)}˚",
      });

      if (freshHourlyList.length >= 24) break;
    }

    hourlyData = freshHourlyList;
    notifyListeners();
  }

  Future<void> refreshWeather() async {
    await _getLocation();
  }

  Future<Position> _getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error("Location services are disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied");
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }

  Future<void> _getLocation() async {
    try {
      Position currentPosition = await _getPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        city = placemarks[0].locality ?? placemarks[0].name ?? "Unknown Location";
      } else {
        city = "Unknown Location";
      }

      position = currentPosition;
      lati = currentPosition.latitude;
      long = currentPosition.longitude;
      notifyListeners();

      await _fetchWeather();
    } catch (e) {
      print("Initialization failed: $e");
      city = "Permission Denied";
      notifyListeners();
    }
  }

  Future<List<dynamic>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? [];
      }
    } catch (e) {
      print("Geocoding API Error: $e");
    }
    return [];
  }

  Future<void> fetchWeatherForCity(double latitude, double longitude, String cityName) async {
    city = cityName;
    lati = latitude;
    long = longitude;
    notifyListeners();

    await _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lati&longitude=$long'
      '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m'
      '&hourly=temperature_2m,precipitation_probability,weather_code'
      '&daily=temperature_2m_max,temperature_2m_min'
      '&timezone=auto&forecast_days=2',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        _rawCurrentTempC = (json["current"]["temperature_2m"] as num).toDouble();
        _rawHumidity = json["current"]["relative_humidity_2m"];
        _rawWindKmh = (json["current"]['wind_speed_10m'] as num).toDouble();
        _rawConditionCode = json["current"]['weather_code'];
        _rawMaxTempC = (json['daily']['temperature_2m_max'][0] as num).toDouble();
        _rawMinTempC = (json['daily']['temperature_2m_min'][0] as num).toDouble();

        _rawHourlyTimes = json['hourly']['time'];
        _rawHourlyTempsC = json['hourly']['temperature_2m'];
        _rawHourlyPrecip = json['hourly']['precipitation_probability'];
        _rawHourlyCodes = json['hourly']['weather_code'];

        _formatWeatherData();
      }
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  String _mapWeatherCode(int code) {
    if (code == 0) return "Sunny";
    if (code >= 1 && code <= 3) return "Cloudy";
    if (code >= 45 && code <= 48) return "Foggy";
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return "Rainy";
    return "Cloudy";
  }
}
