import 'package:flutter/material.dart';
import '../repository/transaction_repository.dart';

class NewTransaction extends StatefulWidget {
  final TransactionRepository repository;
  final Function
      refreshTransactions; // Callback to refresh data in parent screen

  const NewTransaction(
      {required this.repository, required this.refreshTransactions, super.key});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String _selectedCategory = '';
  String _transactionType = 'Expense';
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories(type: 'expense');
  }

  Future<void> _loadCategories({String type = 'expense'}) async {
    final fetchedCategories = await widget.repository.fetchCategories(type);

    setState(() {
      _categories = fetchedCategories;
      _selectedCategory =
          _categories.isNotEmpty ? _categories.first['category'] as String : '';
    });
  }

  void submitData() async {
    final enteredTitle = titleController.text;
    final enteredAmount = double.tryParse(amountController.text) ?? 0;

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedCategory.isEmpty)
      return;

    final category = _categories.firstWhere(
      (cat) => cat['category'] == _selectedCategory,
      orElse: () => <String, dynamic>{}, // Return an empty map
    );

    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category not found in the database')),
      );
      return;
    }

    await widget.repository.addTransaction({
      'type': _transactionType.toLowerCase(),
      'title': enteredTitle,
      'amount': enteredAmount,
      'category': category['id'],
      'date': DateTime.now().toIso8601String(),
    });

    widget.refreshTransactions(); // Refresh transactions in parent
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: _transactionType,
              items:
                  ['Expense', 'Income'].map<DropdownMenuItem<String>>((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (newType) {
                setState(() {
                  _transactionType = newType!;
                  _loadCategories(type: newType.toLowerCase());
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                prefixIcon: const Icon(Icons.title),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              controller: titleController,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.attach_money),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              controller: amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            if (_categories.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                value: _selectedCategory,
                items: _categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category['category'] as String,
                    child: Text(category['category'] as String),
                  );
                }).toList(),
                onChanged: (newCategory) {
                  setState(() {
                    _selectedCategory = newCategory!;
                  });
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: submitData,
              child: const Text(
                'Add Transaction',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
