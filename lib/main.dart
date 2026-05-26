import 'package:flutter/material.dart';
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
 int refreshMinutes = 1;
 Timer? _timer;

 String city = "Lahore";
 String day = "Wednesday–27 October.";
 String temp = "--˚";
 String tempRange = "17˚–14˚";
 String msg = "Yes, It's raining";
 String wind = "Wind: 11km/h";
 String percipitation = "Percipitation: 15%";

 List<Map<String, String>> data = [
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

 @override
 void initState() {
   super.initState();
   fetchWeather();

   _timer = Timer.periodic(Duration(minutes: refreshMinutes), (timer) {
     fetchWeather();
   });
 }

 @override
 void dispose() {
   _timer?.cancel();
   super.dispose();
 }

 Future<void> fetchWeather() async {
   final url = Uri.parse(
     'https://api.open-meteo.com/v1/forecast?latitude=31.55&longitude=74.35&current=temperature_2m',
   );

   try {
     final response = await http.get(url);

     if (response.statusCode == 200) {
       final Map<String, dynamic> data = jsonDecode(response.body);
       final double currentTemp = data["current"]["temperature_2m"];

       setState(() {
         temp = "${currentTemp.toStringAsFixed(0)}˚";
       });
     }
   } catch (e) {
     print("Error fetching weather: $e");
   }
 }

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
               city: city,
               day: day,
               temp: temp,
               msg: msg,
               tempRange: tempRange,
               wind: wind,
               percipitation: percipitation,

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
