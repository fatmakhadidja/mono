import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class TransactionTypeTextForm extends StatefulWidget {
  final TextEditingController controller;
  const TransactionTypeTextForm({super.key, required this.controller});

  @override
  State<TransactionTypeTextForm> createState() =>
      _TransactionTypeTextFormState();
}

class _TransactionTypeTextFormState extends State<TransactionTypeTextForm> {
  final List<String> transactionTypes = ["Expense", "Income"];
  String? selectedType;

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedType = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
        value: selectedType,
        items: transactionTypes
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: AppTextStyles.body1(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedType = value;
            widget.controller.text = value!;
          });
        },
        decoration: InputDecoration(
          label: Text(
           "Transaction Type*",
            style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 18),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1.7),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select a transaction type";
          }
          return null;
        },
      );
  }
}
