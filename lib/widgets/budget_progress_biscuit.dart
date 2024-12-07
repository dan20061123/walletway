import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BudgetBiscuit extends StatelessWidget {
  final double availableToSpend;
  final double totalBudget;

  const BudgetBiscuit({
    Key? key,
    required this.availableToSpend,
    required this.totalBudget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spent = totalBudget - availableToSpend;
    final spentPercentage = totalBudget > 0 ? (spent / totalBudget) : 0.0;

    // Determine the color for the remaining amount
    Color remainingColor;
    final remainingPercentage = availableToSpend / totalBudget;
    if (remainingPercentage > 0.5) {
      remainingColor = Colors.green; // More than 50% remaining
    } else if (remainingPercentage > 0.2) {
      remainingColor = Colors.yellow; // Between 20% and 50% remaining
    } else {
      remainingColor = Colors.red; // Less than 20% remaining
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Full grey background (spent portion)
            CircularPercentIndicator(
              radius: 90.0,
              lineWidth: 12.0,
              percent: 1.0, // Full circle
              backgroundColor: Colors.transparent,
              progressColor: Colors.grey, // Grey for spent portion
              circularStrokeCap: CircularStrokeCap.round,
            ),
            // Dynamic remaining color overlay
            CircularPercentIndicator(
              radius: 90.0,
              lineWidth: 12.0,
              percent: (availableToSpend / totalBudget).clamp(0.0, 1.0), // Remaining portion
              backgroundColor: Colors.transparent,
              progressColor: remainingColor, // Remaining amount color
              circularStrokeCap: CircularStrokeCap.round,
            ),
            // Center text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Available to spend',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${availableToSpend.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: remainingColor, // Dynamic text color
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${(spentPercentage * 100).clamp(0, 100).toStringAsFixed(0)}% spent',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
