// lib/repository/transaction_repository.dart
import '../database/database_helper.dart';

class TransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> fetchCategories(String type) async {
    return await _dbHelper.getCategoriesByType(type);
  }

  Future<void> addTransaction(Map<String, dynamic> transactionData) async {
    await _dbHelper.insertTransaction(transactionData);
  }

  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    return await _dbHelper.getTransactionsOrderedByDate();
  }

  Future<double> getTotalBudget() async {
    final totalBudget = await _dbHelper.getTotalBudget();
    print('Total Budget: $totalBudget');
    return totalBudget;
  }

  Future<double> getTotalExpensesForCurrentMonth() async {
    final totalExpenses = await _dbHelper.getTotalExpensesForCurrentMonth();
    print('Total Expenses: $totalExpenses');
    return totalExpenses;
  }
}
