import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpectacularLineChart extends StatelessWidget {
  final Color color;

  const SpectacularLineChart({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false), // Hide grid for a clean look
        titlesData: FlTitlesData(show: false), // Hide axis titles and labels
        borderData: FlBorderData(show: false), // No borders around the graph
        minX: 0,
        maxX: 3, // Number of points - 1
        minY: 0,
        maxY: 1, // Normalize values between 0 and 1
        lineBarsData: [
          LineChartBarData(
            isCurved: true, // Smooth curved line
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.4)],
            ), // Line gradient
            spots: [
              const FlSpot(0, 0.4),
              const FlSpot(1, 0.6),
              const FlSpot(2, 0.5),
              const FlSpot(3, 0.7),
            ], // Example data points
            barWidth: 3, // Thickness of the line
            isStrokeCapRound: true, // Round caps for the line
            belowBarData: BarAreaData(
              show: true, // Show shaded area below the line
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(show: false), // Hide dots for this design
          ),
        ],
        lineTouchData: LineTouchData(enabled: false), // Correct way to disable touch interactions
      ),
    );
  }
}
