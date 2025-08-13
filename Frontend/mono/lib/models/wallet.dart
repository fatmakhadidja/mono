import 'package:mono/models/transaction.dart';

class Wallet {
  final double balance;
  final double incomeAmount;
  final double expenseAmount;
  final List<Transaction> transactions;

  Wallet({required this.balance, required this.incomeAmount, required this.expenseAmount, required this.transactions});
}