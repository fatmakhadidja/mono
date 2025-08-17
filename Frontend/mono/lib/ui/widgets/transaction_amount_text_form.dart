import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:flutter/services.dart';

class TransactionAmountTextForm extends StatefulWidget {
  final TextEditingController controller;
  const TransactionAmountTextForm({super.key, required this.controller});

  @override
  State<TransactionAmountTextForm> createState() =>
      _TransactionAmountTextFormState();
}

class _TransactionAmountTextFormState extends State<TransactionAmountTextForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number, // 📌 numeric keyboard
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],

      decoration: InputDecoration(
        prefix: Text(
          "DZD  ",
          style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 14),
        ),

        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  widget.controller.clear();
                  setState(() {}); // Update UI after clearing
                },
                icon: Icon(Icons.clear_rounded, color: AppColors.darkGrey),
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          "Transaction Amount*",
          style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 18),
        ),
        hint: Text(
          "0.0",
          style: AppTextStyles.body1(color: AppColors.lightGrey, fontSize: 14),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.7),
        ),
        focusColor: AppColors.primary,
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Transaction amount cannot be empty";
        }

        return null;
      },
    );
  }
}
