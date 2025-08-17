import 'package:flutter/material.dart';
import 'package:mono/ui/widgets/transaction_amount_text_form.dart';
import 'package:mono/ui/widgets/transaction_date_text_form.dart';
import 'package:mono/ui/widgets/transaction_name_text_form.dart';
import 'package:mono/ui/widgets/transaction_type_text_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionContainer extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController transactionNameController;
  final TextEditingController transactionAmountController;
  final TextEditingController transactionDateController;
  final TextEditingController transactionTypeController;

  const TransactionContainer({
    super.key,
    required this.transactionNameController,
    required this.transactionAmountController,
    required this.transactionDateController,
    required this.transactionTypeController,
    required this.formKey,
  });

  @override
  State<TransactionContainer> createState() => _TransactionContainerState();
}

class _TransactionContainerState extends State<TransactionContainer> {
  double balance = 0.0; // will hold balance from SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadBalance(); // load prefs asynchronously
  }

  Future<void> _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      balance = prefs.getDouble("balance") ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TransactionTypeTextForm(
              controller: widget.transactionTypeController,
            ),
            TransactionNameTextForm(
              controller: widget.transactionNameController,
            ),
            TransactionAmountTextForm(
              controller: widget.transactionAmountController,
              balance: balance,
              transactionTypeController: widget.transactionTypeController,
            ),
            TransactionDateTextForm(
              controller: widget.transactionDateController,
            ),
          ],
        ),
      ),
    );
  }
}
