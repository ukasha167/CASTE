import 'package:flutter/material.dart';

class HourlyData extends StatelessWidget {
  final List<Map<String, String>> data;

  const HourlyData({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var hourData in data) ...[
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
