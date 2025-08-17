class Transaction {
  final double amount;
  final String name;
  final bool income;
  final String date;

  Transaction({
    required this.amount,
    required this.name,
    required this.income,
    required this.date,
  });

  // Convert Transaction -> JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'name': name,
      'income': income,
      'date': date,
    };
  }

  // Convert JSON -> Transaction
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount']?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
      income: json['income'] ?? false,
      date: json['date'] ?? '',
    );
  }
}
