import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/weather_controller.dart';

class AtGlance extends StatelessWidget {
  final DailyForecast forecast;
  final String city;

  const AtGlance({required this.forecast, required this.city, super.key});

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
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w800,
                fontSize: screenWidth * 0.09,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
                letterSpacing: 5,
              ),
            ),
            Text(
              forecast.dayString,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.055,
                color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
                letterSpacing: 3,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.23,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      forecast.heroTemp,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w900,
                        fontSize: screenHeight * 0.23,
                        color: Colors.deepOrange[50],
                        letterSpacing: 1,
                        height: 1.0,
                      ),
                    ),
                    if (forecast.heroLabel.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.035, left: 5),
                        child: Text(
                          forecast.heroLabel,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.05,
                            color: Colors.deepOrange[50]!.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  forecast.msg,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.055,
                    color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  forecast.tempRange,
                  style: GoogleFonts.montserrat(
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
                  forecast.wind,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.048,
                    color: Colors.deepOrange[50]!.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  forecast.humidity,
                  style: GoogleFonts.montserrat(
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
