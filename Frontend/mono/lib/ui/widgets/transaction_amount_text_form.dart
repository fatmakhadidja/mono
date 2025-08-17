import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:flutter/services.dart';

class TransactionAmountTextForm extends StatefulWidget {
  final TextEditingController controller;
  final double balance;
  final TextEditingController transactionTypeController;

  const TransactionAmountTextForm({super.key, required this.controller, required this.balance, required this.transactionTypeController});

  @override
  State<TransactionAmountTextForm> createState() =>
      _TransactionAmountTextFormState();
}

class _TransactionAmountTextFormState extends State<TransactionAmountTextForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {}); // Rebuild when text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        // ✅ allows decimals like 123.45 (max 2 decimal places)
      ],
      decoration: InputDecoration(
        prefix: Text(
          "DZD  ",
          style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 14),
        ),
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  widget.controller.clear();
                  setState(() {});
                },
                icon: Icon(Icons.clear_rounded, color: AppColors.darkGrey),
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          "Transaction Amount*",
          style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 18),
        ),
        hintText: "0.0",
        hintStyle: AppTextStyles.body1(
          color: AppColors.lightGrey,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.7),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Transaction amount cannot be empty";
        }
        final parsed = double.tryParse(value.trim());
        if (parsed == null) {
          return "Enter a valid number";
        }
        if (parsed <= 0) {
          return "Amount must be greater than 0";
        }
        final isIncome = widget.transactionTypeController.text == "Income";
        if (parsed > widget.balance && !isIncome) {
          return "Amount exceeds available wallet balance";
        }
        return null;
      },
    );
  }
}
