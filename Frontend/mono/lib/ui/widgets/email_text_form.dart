import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class EmailTextForm extends StatefulWidget {
  const EmailTextForm({super.key});

  @override
  State<EmailTextForm> createState() => _EmailTextFormState();
}

class _EmailTextFormState extends State<EmailTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          "Email*",
          style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 18),
        ),
        hint: Text(
          "example@gmail.com",
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
        if (!value!.contains('@') && value.isNotEmpty) {
          return "Invalid email format";
        }
        if (value.isEmpty) {
          return "Email cannot be empty";
        }
        return null;
      },
    );
  }
}
