import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'budget_screen.dart';
import '../models/transaction.dart';
import '../widgets/new_transaction.dart';
import '../widgets/spectacular_line_chart.dart';
import '../widgets/custom_footer.dart';
import '../widgets/budget_progress_biscuit.dart';
import '../database/database_helper.dart';
import '../repository/transaction_repository.dart';
import '../helpers/icon_mapper.dart'; // Import your mapper

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transaction> _userTransactions = [];
  final TransactionRepository _transactionRepository = TransactionRepository();

  double _totalBudget = 0.0;
  double _totalExpenses = 0.0;
  double _availableToSpend = 0.0;

  Future<void> _loadTransactions() async {
    final dbHelper = DatabaseHelper();
    final fetchedTransactions = await dbHelper.getTransactionsOrderedByDate();

    setState(() {
      _userTransactions = fetchedTransactions.map((tx) {
        return Transaction(
          id: tx['id'].toString(),
          title: tx['title'] as String,
          amount: tx['amount'] as double,
          date: DateTime.parse(tx['date'] as String),
          category: tx['category'] as String, // Keep category name
          type: tx['type'] as String,
          iconName: tx['icon_name'] as String, // Include icon_name
        );
      }).toList();
    });
  }

  Future<void> _loadBudgetData() async {
    try {
      final totalBudget =
          await _transactionRepository.getTotalBudget();
      final totalExpenses =
          await _transactionRepository.getTotalExpensesForCurrentMonth();
      final availableToSpend = totalBudget - totalExpenses;

      setState(() {
        _totalBudget = totalBudget;
        _totalExpenses = totalExpenses;
        _availableToSpend = availableToSpend;
      });
    } catch (e) {
      print('Error loading budget data: $e');
    }
  }

  double _calculateMonthlyTotal(String type) {
    final now = DateTime.now();
    return _userTransactions
        .where((tx) =>
            tx.type.toLowerCase() == type.toLowerCase() &&
            tx.date.year == now.year &&
            tx.date.month == now.month)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // Load transactions when screen is initialized
    _loadBudgetData();
  }

  void openAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => NewTransaction(
        repository: _transactionRepository,
        refreshTransactions:
            _loadTransactions, // Refresh transactions after adding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs for December, January, February
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text('Activity', style: TextStyle(color: Colors.black)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'December 2018'),
              Tab(text: 'January 2019'),
              Tab(text: 'February 2019'),
            ],
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTabContent(), // For December
                      _buildTabContent(), // For January
                      _buildTabContent(), // For February
                    ],
                  ),
                ),
              ],
            ),
            // Custom Positioned Floating Action Button
            Positioned(
              bottom: 20, // Move up from default
              right: 14, // Move slightly inward
              child: FloatingActionButton(
                onPressed: () {
                  openAddNewTransaction(context);
                },
                backgroundColor: Colors.teal,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Widget _buildTabContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryCard(
                'Spent',
                _calculateMonthlyTotal('Expense'),
                'Expenses this month',
                Colors.red,
              ),
              _summaryCard(
                'Earned',
                _calculateMonthlyTotal('Income'),
                'Income this month',
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _budgetSection(_totalExpenses, _totalBudget),
          const SizedBox(height: 20),
          Expanded(
            child: _userTransactions.isEmpty
                ? const Center(
                    child: Text(
                      'No transactions yet. Click + to add!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView(
                    children: _groupTransactionsByDate().entries.map((entry) {
                      final date = entry.key;
                      final transactions = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              date,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 82, 76, 76),
                              ),
                            ),
                          ),
                          ...transactions.map((tx) => _transactionTile(tx)),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
      String title, double amount, String description, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Line graph positioned above the text
              const Positioned(
                top: -10,
                right: 0,
                child: SizedBox(
                  width: 60,
                  height: 40,
                  child: SpectacularLineChart(color: Colors.white),
                ),
              ),
              // Text content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _budgetSection(double spent, double budget) {
    final availableToSpend = budget - spent;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Budget Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            BudgetBiscuit(
              availableToSpend: availableToSpend,
              totalBudget: budget,
            ),
            const SizedBox(height: 20),
            if (budget > 0) // Only show this row if budget is set
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spent: £${spent.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    'Budget: £${budget.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(Transaction tx) {
    final iconData = getIcon(tx.iconName);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: tx.type.toLowerCase() == 'expense'
                  ? Colors.red[100]
                  : Colors.green[100],
              child: Icon(
                iconData,
                color: tx.type.toLowerCase() == 'expense'
                    ? Colors.red
                    : Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.title, style: const TextStyle(fontSize: 16)),
                  Text(tx.category,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Text(
              '${tx.type.toLowerCase() == 'expense' ? '-' : ''}\$${tx.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByDate() {
    final Map<String, List<Transaction>> groupedTransactions = {};
    for (var tx in _userTransactions) {
      final formattedDate = DateFormat('EEEE, MMM d').format(tx.date);
      groupedTransactions.putIfAbsent(formattedDate, () => []).add(tx);
    }
    return groupedTransactions;
  }
}
