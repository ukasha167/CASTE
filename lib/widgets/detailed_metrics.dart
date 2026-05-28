import 'package:flutter/material.dart';

class DetailedMetrics extends StatelessWidget {
  const DetailedMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detailed Metrics",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.deepOrange[50],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "coming soon...",
            style: TextStyle(
              color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
            ),
          )
        ],
      ),
    );
  }
}
