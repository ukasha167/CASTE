import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/weather_controller.dart';

class DetailedMetrics extends StatelessWidget {
  final DailyForecast forecast;

  const DetailedMetrics({required this.forecast, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 65, child: _buildAqiCard(screenWidth)),
            const SizedBox(width: 15),
            Expanded(flex: 35, child: _buildUvCard(screenWidth)),
          ],
        ),
        const SizedBox(height: 15),

        _buildSunriseCard(screenWidth),
        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: _buildSquareCard(
                "Wind",
                forecast.windSpeedOnly,
                forecast.windUnitOnly,
                screenWidth,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildSquareCard(
                "Pressure",
                forecast.pressure.split(' ')[0],
                forecast.pressure.split(' ')[1],
                screenWidth,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: _buildSquareCard(
                "Visibility",
                forecast.visibility.split(' ')[0],
                forecast.visibility.split(' ')[1],
                screenWidth,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildSquareCard(
                "Cloud Cover",
                forecast.cloudCover.replaceAll('%', ''),
                "%",
                screenWidth,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAqiCard(double screenWidth) {
    return Container(
      height: 170,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "AQI",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.deepOrange[50]!.withValues(alpha: 0.8),
            ),
          ),
          Text(
            forecast.aqi,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w900,
              fontSize: screenWidth * 0.17,
              color: Colors.deepOrange[50],
              height: 1.0,
            ),
          ),
          Text(
            forecast.aqiLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.deepOrange[50],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUvCard(double screenWidth) {
    return Container(
      height: 170,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "UV",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.deepOrange[50]!.withValues(alpha: 0.8),
            ),
          ),
          Text(
            forecast.uv,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w900,
              fontSize: screenWidth * 0.17,
              color: Colors.deepOrange[50],
              height: 1.0,
            ),
          ),
          Text(
            forecast.uvLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.deepOrange[50],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareCard(
    String title,
    String value,
    String unit,
    double screenWidth,
  ) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.07,
                  color: Colors.deepOrange[50],
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.deepOrange[50],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunriseCard(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sunrise & Sunset",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: SunrisePainter(progress: forecast.daylightProgress),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                forecast.sunrise,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  color: Colors.deepOrange[50],
                ),
              ),
              Text(
                forecast.sunset,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  color: Colors.deepOrange[50],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SunrisePainter extends CustomPainter {
  final double progress;
  SunrisePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    final double startX = 10;
    final double endX = size.width - 10;
    final double baseY = size.height;

    path.moveTo(startX, baseY);
    path.quadraticBezierTo(size.width / 2, -size.height * 0.15, endX, baseY);
    canvas.drawPath(path, trackPaint);

    if (progress >= 0.0 && progress <= 1.0) {
      final sunPaint = Paint()
        ..color = Colors.deepOrange[50]!
        ..style = PaintingStyle.fill;

      final sunGlow = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      double t = progress;
      double x =
          (1 - t) * (1 - t) * startX +
          2 * (1 - t) * t * (size.width / 2) +
          t * t * endX;
      double y =
          (1 - t) * (1 - t) * baseY +
          2 * (1 - t) * t * (-size.height * 0.15) +
          t * t * baseY;

      canvas.drawCircle(Offset(x, y), 12, sunGlow);
      canvas.drawCircle(Offset(x, y), 6, sunPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SunrisePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
