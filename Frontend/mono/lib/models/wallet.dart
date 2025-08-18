import 'package:mono/models/transaction.dart';

class Wallet {
  double balance;
  double incomeAmount;
  double expenseAmount;
  final List<Transaction> transactions;

  Wallet({
    required this.balance,
    required this.incomeAmount,
    required this.expenseAmount,
    required this.transactions,
  });
}
