import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mono/models/transaction.dart';
import 'package:mono/models/wallet.dart';

class WalletService {
  Future<Wallet?> getWalletInfo() async {
    String baseUrl = "http://192.168.1.9:8081/api/wallet";
    try {
      // Retrieve the stored token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception("No token found. User might not be logged in.");
      }

      // Make the API call
      final response = await http.get(
        Uri.parse("$baseUrl/getWalletInfo"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Map transactions
        List<Transaction> transactions = (data['transactions'] as List)
            .map(
              (t) => Transaction(
                amount: t['amount'].toDouble(),
                title: t['title'],
                income: t['income'],
                date: t['date'],
              ),
            )
            .toList();

        // Calculate income and expense amounts
        double incomeAmount = 0.0;
        double expenseAmount = 0.0;
        for (var tx in transactions) {
          if (tx.income) {
            incomeAmount += tx.amount;
          } else {
            expenseAmount += tx.amount;
          }
        }

        // Return wallet
        return Wallet(
          balance: data['balance'].toDouble(),
          incomeAmount: incomeAmount,
          expenseAmount: expenseAmount,
          transactions: transactions,
        );
      } else {
        throw Exception(
          "Failed to fetch wallet info: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("Error fetching wallet info: $e");
      return null;
    }
  }


}
