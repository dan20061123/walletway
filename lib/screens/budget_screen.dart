import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../widgets/custom_footer.dart';
import '../database/database_helper.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _overallBudgetController = TextEditingController();
  final Map<int, TextEditingController> _categoryBudgetControllers = {};
  List<Map<String, dynamic>> _categories = [];
  double? _overallBudget;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadOverallBudget();
  }

  Future<void> _loadCategories() async {
    final dbHelper = DatabaseHelper();
    final fetchedCategories = await dbHelper.getCategoriesByType('spending');
    setState(() {
      _categories = fetchedCategories;
      for (var category in _categories) {
        _categoryBudgetControllers[category['id']] = TextEditingController();
      }
    });
  }

  Future<void> _loadOverallBudget() async {
    final dbHelper = DatabaseHelper();
    final budgets = await dbHelper.getOverallBudget();
    if (budgets.isNotEmpty) {
      setState(() {
        _overallBudget = budgets.first['amount'];
        _overallBudgetController.text = _overallBudget.toString();
      });
    }
  }

  Future<void> _saveOverallBudget() async {
    final enteredAmount = double.tryParse(_overallBudgetController.text) ?? 0.0;
    final dbHelper = DatabaseHelper();
    await dbHelper.saveOverallBudget(enteredAmount);
    setState(() {
      _overallBudget = enteredAmount;
    });
  }

  Future<void> _saveCategoryBudget(int categoryId, String amount) async {
    final enteredAmount = double.tryParse(amount) ?? 0.0;
    final dbHelper = DatabaseHelper();
    await dbHelper.saveCategoryBudget(categoryId, enteredAmount);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category budget saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: const Text('Set Budgets', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overall Budget',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _overallBudgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter overall budget',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveOverallBudget,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Save Overall Budget'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Category Budgets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          category['category'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller:
                              _categoryBudgetControllers[category['id']],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter budget',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                          onSubmitted: (value) =>
                              _saveCategoryBudget(category['id'], value),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
