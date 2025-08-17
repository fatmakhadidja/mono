import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class TransactionNameTextForm extends StatefulWidget {
  final TextEditingController controller;
  const TransactionNameTextForm({super.key, required this.controller});

  @override
  State<TransactionNameTextForm> createState() =>
      _TransactionNameTextFormState();
}

class _TransactionNameTextFormState extends State<TransactionNameTextForm> {
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
        decoration: InputDecoration(
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
            "Transaction Name*",
            style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 18),
          ),
          hint: Text(
            "Enter transaction name",
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
            return "Transaction name cannot be empty";
          }
      
          return null;
        },
      );
  }
}
