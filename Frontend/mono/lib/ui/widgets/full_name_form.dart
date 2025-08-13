import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class FullNameForm extends StatefulWidget {
  final TextEditingController controller;

  const FullNameForm({super.key, required this.controller});

  @override
  State<FullNameForm> createState() => _FullNameFormState();
}

class _FullNameFormState extends State<FullNameForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          "Full Name*",
          style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 18),
        ),
        hint: Text(
          "Jane Doe",
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
        if (value!.isEmpty) {
          return "Full name cannot be empty";
        }
        return null;
      },
    );
  }
}
