class Transaction {
  int id;
  final double amount;
  final String name;
  final bool income;
  final String date;

  Transaction({
    required this.id,
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
      id: json['id'] ?? 0,
      amount: json['amount']?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
      income: json['income'] ?? false,
      date: json['date'] ?? '',
    );
  }
}
