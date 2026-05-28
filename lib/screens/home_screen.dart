import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../widgets/at_glance.dart';
import '../widgets/hourly_data.dart';
import '../widgets/detailed_metrics.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          if (parsedTime.isBefore(now.subtract(const Duration(minutes: 59))))
            continue;

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
    if (code == 0) return "Sunny";
    if (code >= 1 && code <= 3) return "Cloudy";
    if (code >= 45 && code <= 48) return "Foggy";
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82))
      return "Rainy";
    return "Cloudy";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight <= 0) {
      return const Scaffold();
    }

    final myAppBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 75,
      leading: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, size: 26, weight: 700),
          color: Colors.deepOrange[50],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 26, weight: 700),
            color: Colors.deepOrange[50],
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Divider(indent: 30, endIndent: 30),
      ),
    );

    final statusBarHeight = MediaQuery.of(context).padding.top;
    final availableHeight = (screenHeight - myAppBar.preferredSize.height - statusBarHeight) - 145.0;

    return Scaffold(
      appBar: myAppBar,

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: availableHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 57,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: double.infinity,
                          child: AtGlance(
                            city: city,
                            day: day,
                            temp: temp,
                            msg: msg,
                            tempRange: tempRange,
                            wind: wind,
                            humidity: humidity,
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 43,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hourly",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.055,
                              color: Colors.deepOrange[50]!.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _headerText("TIME", 75, TextAlign.left, context),
                              _headerText(
                                "FORECAST",
                                80,
                                TextAlign.left,
                                context,
                              ),
                              _headerText(
                                "RAIN %",
                                70,
                                TextAlign.left,
                                context,
                              ),
                              _headerText(
                                "TEMP",
                                45,
                                TextAlign.center,
                                context,
                              ),
                            ],
                          ),
                          const Divider(),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: HourlyData(data: data),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 30,
                top: 10,
              ),
              child: const DetailedMetrics(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _headerText(
    String title,
    double width,
    TextAlign align,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * (width / 412),
      child: Text(
        title,
        textAlign: align,
        style: TextStyle(
          fontSize: screenWidth * 0.026,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: Colors.deepOrange[50]!.withValues(alpha: 0.60),
        ),
      ),
    );
  }
}
