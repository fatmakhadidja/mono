import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class PasswordTextForm extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const PasswordTextForm({super.key, required this.label, required this.controller});

  @override
  State<PasswordTextForm> createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {

  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !visible,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              visible = !visible;
            });
          },
          icon: Icon(
            Icons.visibility,
            color: visible ? AppColors.primary : AppColors.darkGrey,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          widget.label,
          style: AppTextStyles.body1(color: AppColors.darkGrey, fontSize: 18),
        ),
        hint: Text(
          "************",
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
          return "Password cannot be empty";
        }
        return null;
      },
    );
  }
}
