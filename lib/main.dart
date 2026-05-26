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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "12 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "01 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "02 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "03 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "04 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "05 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "06 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "07 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "08 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "09 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "10 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "11 Am",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "12 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "01 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "02 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "03 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "04 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "05 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "06 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "07 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "08 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "09 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "10 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "11 Pm",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Sunny",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Sunny",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Sunny",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Rainy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Sunny",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Cloudy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "• 75%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 53%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 14%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 7%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 86%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 67%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 75%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 53%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 14%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 7%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 86%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 67%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 75%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 53%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 14%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 7%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 86%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 67%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 75%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 53%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 14%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 7%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 86%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "• 67%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "13˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "14˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "15˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "16˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "14˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "13˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "13˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "14˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "15˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "16˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "14˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "13˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "13˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "14˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "15˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "16˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "14˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "13˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "13˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "14˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "15˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "16˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "14˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "13˚",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ],
    );
  }
}
