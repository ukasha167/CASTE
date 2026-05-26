import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String _city = "Lahore";
  final String _day = "Wednesday–27 October.";
  final String _temp = "20˚";
  final String _tempRange = "17˚–14˚";
  final String _msg = "Yes, It's raining";
  final String _wind = "Wind: 11km/h";
  final String _percipitation = "Percipitation: 15%";

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 6, 68, 255),
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
                city: _city,
                day: _day,
                temp: _temp,
                msg: _msg,
                tempRange: _tempRange,
                wind: _wind,
                percipitation: _percipitation,
              ),
              SizedBox(height: 5),
              Text(
                "Hourly",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
                ),
              ),
              Divider(),
              Expanded(child: SingleChildScrollView(child: HourlyData())),
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
  final String percipitation;

  const AtGlance({
    required this.city,
    required this.day,
    required this.temp,
    required this.tempRange,
    required this.msg,
    required this.wind,
    required this.percipitation,
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
              percipitation,
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
  const HourlyData({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockHours = [
      {"time": "12 Am", "weather": "Rainy", "precip": "• 75%", "temp": "13˚"},
      {"time": "01 Am", "weather": "Rainy", "precip": "• 53%", "temp": "14˚"},
      {"time": "02 Am", "weather": "Cloudy", "precip": "• 14%", "temp": "15˚"},
      {"time": "03 Am", "weather": "Sunny", "precip": "• 7%", "temp": "16˚"},
      {"time": "04 Am", "weather": "Cloudy", "precip": "• 86%", "temp": "14˚"},
      {"time": "05 Am", "weather": "Rainy", "precip": "• 75%", "temp": "13˚"},
      {"time": "06 Am", "weather": "Rainy", "precip": "• 53%", "temp": "14˚"},
      {"time": "07 Am", "weather": "Cloudy", "precip": "• 14%", "temp": "15˚"},
      {"time": "08 Am", "weather": "Sunny", "precip": "• 7%", "temp": "16˚"},
      {"time": "09 Am", "weather": "Cloudy", "precip": "• 86%", "temp": "14˚"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var hourData in mockHours) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hourData["time"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    hourData["weather"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    hourData["precip"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
                    ),
                  ),
                ),

                Expanded(
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
