import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HourlyData extends StatelessWidget {
  final List<Map<String, String>> data;

  const HourlyData({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final rowFontSize = screenWidth * 0.042;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var hourData in data) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.18,
                  child: Text(
                    hourData["time"]!,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: rowFontSize,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.20,
                  child: Text(
                    hourData["weather"]!,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: rowFontSize,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.18,
                  child: Text(
                    hourData["precip"]!,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: rowFontSize,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.10,
                  child: Text(
                    hourData["temp"]!,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: rowFontSize,
                      color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
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
