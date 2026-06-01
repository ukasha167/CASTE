import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/weather_controller.dart';

class SettingsDrawer extends StatelessWidget {
  final WeatherController controller;

  const SettingsDrawer({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.75,

      backgroundColor: const Color.fromARGB(255, 6, 68, 225),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  color: Colors.deepOrange[50],
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              _buildSettingRow(
                title: "Temperature",
                child: CupertinoSlidingSegmentedControl<bool>(
                  groupValue: controller.isCelsius,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  thumbColor: Colors.deepOrange[50]!,
                  children: {
                    true: _toggleText("°C", controller.isCelsius),
                    false: _toggleText("°F", !controller.isCelsius),
                  },
                  onValueChanged: (value) {
                    if (value != null) controller.toggleTempUnit(value);
                  },
                ),
              ),

              const SizedBox(height: 30),

              _buildSettingRow(
                title: "Distance",
                child: CupertinoSlidingSegmentedControl<bool>(
                  groupValue: controller.isMetric,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  thumbColor: Colors.deepOrange[50]!,
                  children: {
                    true: _toggleText("km/h", controller.isMetric),
                    false: _toggleText("m/h", !controller.isMetric),
                  },
                  onValueChanged: (value) {
                    if (value != null) controller.toggleDistanceUnit(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow({required String title, required Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.deepOrange[50]!.withValues(alpha: 0.85),
          ),
        ),
        child,
      ],
    );
  }

  Widget _toggleText(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          color: isSelected
              ? const Color.fromARGB(255, 6, 68, 225)
              : Colors.deepOrange[50],
        ),
      ),
    );
  }
}
