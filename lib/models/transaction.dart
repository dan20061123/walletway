class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;
  String category;
  String type; // "Income" or "Expense"
  String iconName;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    required this.iconName,
  });
}
