import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class EmailTextForm extends StatefulWidget {
  final TextEditingController controller;
  const EmailTextForm({super.key, required this.controller});

  @override
  State<EmailTextForm> createState() => _EmailTextFormState();
}

class _EmailTextFormState extends State<EmailTextForm> {
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
                  setState(() {}); // Update UI after clearing
                },
                icon: Icon(Icons.clear_rounded, color: AppColors.darkGrey),
              )
            : null,
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
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,3}$');

        if (value == null || value.isEmpty) {
          return "Email cannot be empty";
        }
        if (!emailRegex.hasMatch(value)) {
          return "Invalid email format";
        }
        return null;
      },
    );
  }
}
