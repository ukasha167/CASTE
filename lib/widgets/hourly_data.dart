import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HourlySection extends StatelessWidget {
  final List<Map<String, String>> data;

  const HourlySection({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hourly",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.055,
            color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _headerText("TIME", 75, TextAlign.left, context),
            _headerText("FORECAST", 80, TextAlign.left, context),
            _headerText("RAIN %", 70, TextAlign.left, context),
            _headerText("TEMP", 45, TextAlign.center, context),
          ],
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _buildList(screenWidth),
          ),
        ),
      ],
    );
  }

  Widget _buildList(double screenWidth) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final rowFontSize = screenWidth * 0.041;

    return Column(
      children: data.map((hourData) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cellText(
                hourData["time"]!,
                screenWidth * 0.20,
                TextAlign.start,
                rowFontSize,
              ),
              _cellText(
                hourData["weather"]!,
                screenWidth * 0.19,
                TextAlign.start,
                rowFontSize,
              ),
              _cellText(
                hourData["precip"]!,
                screenWidth * 0.18,
                TextAlign.start,
                rowFontSize,
              ),
              _cellText(
                hourData["temp"]!,
                screenWidth * 0.10,
                TextAlign.end,
                rowFontSize,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _cellText(
    String text,
    double width,
    TextAlign align,
    double fontSize,
  ) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
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
        style: GoogleFonts.montserrat(
          fontSize: screenWidth * 0.026,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
