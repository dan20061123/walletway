import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  final VoidCallback onDashboardTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onTargetTap;
  final VoidCallback onStatsTap;
  final VoidCallback onCategoriesTap;

  const CustomFooter({
    required this.onDashboardTap,
    required this.onHistoryTap,
    required this.onTargetTap,
    required this.onStatsTap,
    required this.onCategoriesTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.teal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_filled, color: Colors.white),
            iconSize: 30,
            onPressed: onDashboardTap,
          ),
          IconButton(
            icon: const Icon(Icons.history_sharp, color: Colors.white),
            iconSize: 30,
            onPressed: onHistoryTap,
          ),
          IconButton(
            icon: const Icon(Icons.track_changes, color: Colors.white),
            iconSize: 30,
            onPressed: onTargetTap,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            iconSize: 30,
            onPressed: onStatsTap,
          ),
          IconButton(
            icon: const Icon(Icons.category, color: Colors.white),
            iconSize: 30,
            onPressed: onCategoriesTap,
          ),
        ],
      ),
    );
  }

  Widget customFAB(VoidCallback onFabTap) {
    return FloatingActionButton(
      onPressed: onFabTap,
      backgroundColor: Colors.teal,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
