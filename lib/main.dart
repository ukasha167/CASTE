import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
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

  final List<String> _weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  final List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  List<Map<String, String>> data = [];

  Future<void> _getLocation() async {
    try {
      Position currentPosition = await _getPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      String detectedCity = "Unknown Location";
      if (placemarks.isNotEmpty) {
        detectedCity =
            placemarks[0].locality ?? placemarks[0].name ?? "Unknown Location";
      }

      setState(() {
        position = currentPosition;
        lati = currentPosition.latitude;
        long = currentPosition.longitude;
        city = detectedCity;
      });

      _fetchWeather();
    } catch (e) {
      print("Initialization failed: $e");
      setState(() {
        city = "Permission Denied";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      day = _getDay();
    });

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

  String _getDay() {
    final DateTime now = DateTime.now();

    int date = now.day;
    String day = _weekdays[now.weekday - 1];
    String month = _months[now.month - 1];

    return "$day–$date $month.";
  }

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();
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
      locationSettings: LocationSettings(accuracy: LocationAccuracy.low),
    );
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
        final double currentWind = (json["current"]['wind_speed_10m'] as num)
            .toDouble();
        final int currentConditionCode = json["current"]['weather_code'];

        final double maxTemp = json['daily']['temperature_2m_max'][0];
        final double minTemp = json['daily']['temperature_2m_min'][0];

        final List<dynamic> hourlyTimes = json['hourly']['time'];
        final List<dynamic> hourlyTemps = json['hourly']['temperature_2m'];
        final List<dynamic> hourlyPrecip =
            json['hourly']['precipitation_probability'];
        final List<dynamic> hourlyCodes = json['hourly']['weather_code'];

        List<Map<String, String>> freshHourlyList = [];
        DateTime now = DateTime.now();

        for (int i = 0; i < hourlyTimes.length; i++) {
          DateTime parsedTime = DateTime.parse(hourlyTimes[i]);

          if (parsedTime.isBefore(now.subtract(Duration(minutes: 59)))) {
            continue;
          }

          int hourNum = parsedTime.hour;
          String amPm = hourNum >= 12 ? "Pm" : "Am";
          int displayHour = hourNum % 12 == 0 ? 12 : hourNum % 12;
          String formattedTime =
              "${displayHour.toString().padLeft(2, '0')} $amPm";

          freshHourlyList.add({
            "time": formattedTime,
            "weather": _mapWeatherCode(hourlyCodes[i]),
            "precip": "• ${hourlyPrecip[i]}%",
            "temp": "${(hourlyTemps[i] as num).toStringAsFixed(0)}˚",
          });

          if (freshHourlyList.length >= 24) {
            break;
          }
        }

        setState(() {
          temp = "${currentTemp.toStringAsFixed(0)}˚";
          tempRange =
              "${maxTemp.toStringAsFixed(0)}˚– ${minTemp.toStringAsFixed(0)}˚";
          wind = "Wind: ${currentWind.toStringAsFixed(0)}km/h";
          humidity = "Humidity: $currentHumidity%";
          msg = currentConditionCode >= 50
              ? "Yes, It's raining"
              : "Enjoy your day!";
          data = freshHourlyList;
        });
      }
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  String _mapWeatherCode(int code) {
    if (code == 0) {
      return "Sunny";
    }
    if (code >= 1 && code <= 3) {
      return "Cloudy";
    }
    if (code >= 45 && code <= 48) {
      return "Foggy";
    }
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return "Rainy";
    }
    return "Cloudy";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 6, 68, 225),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 75,
          leading: Padding(
            padding: EdgeInsetsGeometry.only(left: 25),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu, size: 26, weight: 700),
              color: Colors.deepOrange[50],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 30),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search, size: 26, weight: 700),
                color: Colors.deepOrange[50],
              ),
            ),
          ],
          actionsPadding: EdgeInsets.zero,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Divider(indent: 30, endIndent: 30),
          ),
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.only(
            left: 30,
            top: 30,
            right: 30,
            bottom: 30,
          ),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AtGlance(
                city: city,
                day: day,
                temp: temp,
                msg: msg,
                tempRange: tempRange,
                wind: wind,
                humidity: humidity,
              ),
              SizedBox(height: 5),
              Text(
                "Hourly",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
                ),
              ),
              // Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 75,
                      child: Text(
                        "TIME",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.deepOrange[50]!.withValues(alpha: 0.60),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        "FORECAST",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.deepOrange[50]!.withValues(alpha: 0.60),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Text(
                        "RAIN %",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.deepOrange[50]!.withValues(alpha: 0.60),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      child: Text(
                        "TEMP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.deepOrange[50]!.withValues(alpha: 0.60),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: HourlyData(data: data),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AtGlance extends StatelessWidget {
  final String city;
  final String day;
  final String temp;
  final String tempRange;
  final String msg;
  final String wind;
  final String humidity;

  const AtGlance({
    required this.city,
    required this.day,
    required this.temp,
    required this.tempRange,
    required this.msg,
    required this.wind,
    required this.humidity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 38,
            color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
            letterSpacing: 3,
          ),
        ),
        Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
          ),
        ),
        Text(
          temp,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 185,
            color: Colors.deepOrange[50],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              msg,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
              ),
            ),
            Text(
              tempRange,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              wind,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.8),
              ),
            ),
            Text(
              humidity,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HourlyData extends StatelessWidget {
  final List<Map<String, String>> data;

  const HourlyData({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var hourData in data) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 75,
                  child: Text(
                    hourData["time"]!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    hourData["weather"]!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    hourData["precip"]!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
                    ),
                  ),
                ),
                SizedBox(
                  width: 45,
                  child: Text(
                    hourData["temp"]!,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
