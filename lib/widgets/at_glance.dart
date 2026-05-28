import 'package:flutter/material.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: screenWidth,
        child: Column(
          spacing: screenHeight * 0.01,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              city,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: screenWidth * 0.09,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
                letterSpacing: 3,
              ),
            ),
            Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.055,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
              ),
            ),
            Text(
              temp,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: screenHeight * 0.23,
                color: Colors.deepOrange[50],
                height: 1.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.055,
                    color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  tempRange,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.048,
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
                    fontSize: screenWidth * 0.048,
                    color: Colors.deepOrange[50]!.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  humidity,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.048,
                    color: Colors.deepOrange[50]!.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
