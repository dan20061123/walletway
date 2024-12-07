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

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 90.0, // Reduced size
          lineWidth: 12.0, // Reduced line width
          percent: spentPercentage.clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Available to spend',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '£${availableToSpend.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: spentPercentage > 0.75
                      ? Colors.red
                      : spentPercentage > 0.5
                          ? Colors.orange
                          : Colors.green,
                ),
              ),
            ],
          ),
          progressColor: spentPercentage > 0.75
              ? Colors.red
              : spentPercentage > 0.5
                  ? Colors.orange
                  : Colors.green,
          backgroundColor: Colors.grey.withOpacity(0.3),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1000,
          arcType: ArcType.HALF,
          arcBackgroundColor: Colors.grey,
        ),
        const SizedBox(height: 10),
        if (totalBudget == 0) // Show a friendly message if budget is 0
          const Text(
            'No budget set for this month.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        if (spent == 0 &&
            totalBudget > 0) // Friendly message if nothing is spent
          const Text(
            'You have not spent anything yet!',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
      ],
    );
  }
}
