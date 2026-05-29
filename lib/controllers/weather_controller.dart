import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class WeatherController extends ChangeNotifier {
  int refreshMinutes = 30;
  Timer? _timer;

  String city = "Loading...";
  String day = "Unknown Day";
  String temp = "--˚";
  String tempRange = "--˚ – --˚";
  String msg = "Unknown";
  String wind = "Wind: --km/h";
  String humidity = "Humidity: --%";

  Position? position;
  double lati = 0.0;
  double long = 0.0;

  List<Map<String, String>> hourlyData = [];

  final List<String> _weekdays = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
  ];
  final List<String> _months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];

  WeatherController() {
    day = _getDay();
    _getLocation();
    _timer = Timer.periodic(Duration(minutes: refreshMinutes), (timer) {
      _getLocation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void resetFields() {
    city = "Loading...";
    day = "Unknown Day";
    temp = "--˚";
    tempRange = "--˚ – --˚";
    msg = "Unknown";
    wind = "Wind: --km/h";
    humidity = "Humidity: --%";

    position;
    lati = 0.0;
    long = 0.0;

    hourlyData = [];

    notifyListeners();
  }

  String _getDay() {
    final DateTime now = DateTime.now();
    return "${_weekdays[now.weekday - 1]}–${now.day} ${_months[now.month - 1]}.";
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

  Future<void> refreshWeather() async {
    resetFields();
    await _getLocation();
  }

  Future<void> _getLocation() async {
    day = _getDay();
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

        final double currentTemp = json["current"]["temperature_2m"];
        final int currentHumidity = json["current"]["relative_humidity_2m"];
        final double currentWind = (json["current"]['wind_speed_10m'] as num).toDouble();
        final int currentConditionCode = json["current"]['weather_code'];
        final double maxTemp = json['daily']['temperature_2m_max'][0];
        final double minTemp = json['daily']['temperature_2m_min'][0];

        final List<dynamic> hourlyTimes = json['hourly']['time'];
        final List<dynamic> hourlyTemps = json['hourly']['temperature_2m'];
        final List<dynamic> hourlyPrecip = json['hourly']['precipitation_probability'];
        final List<dynamic> hourlyCodes = json['hourly']['weather_code'];

        List<Map<String, String>> freshHourlyList = [];
        DateTime now = DateTime.now();

        for (int i = 0; i < hourlyTimes.length; i++) {
          DateTime parsedTime = DateTime.parse(hourlyTimes[i]);
          if (parsedTime.isBefore(now.subtract(const Duration(minutes: 59)))) continue;

          int hourNum = parsedTime.hour;
          String amPm = hourNum >= 12 ? "Pm" : "Am";
          int displayHour = hourNum % 12 == 0 ? 12 : hourNum % 12;

          freshHourlyList.add({
            "time": "${displayHour.toString().padLeft(2, '0')} $amPm",
            "weather": _mapWeatherCode(hourlyCodes[i]),
            "precip": "• ${hourlyPrecip[i]}%",
            "temp": "${(hourlyTemps[i] as num).toStringAsFixed(0)}˚",
          });

          if (freshHourlyList.length >= 24) break;
        }

        temp = "${currentTemp.toStringAsFixed(0)}˚";
        tempRange = "${maxTemp.toStringAsFixed(0)}˚– ${minTemp.toStringAsFixed(0)}˚";
        wind = "Wind: ${currentWind.toStringAsFixed(0)}km/h";
        humidity = "Humidity: $currentHumidity%";
        msg = currentConditionCode >= 50 ? "Yes, It's raining" : "Enjoy your day!";
        hourlyData = freshHourlyList;

        notifyListeners();
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
