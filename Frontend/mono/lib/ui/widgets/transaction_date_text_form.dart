import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:intl/intl.dart';

class TransactionDateTextForm extends StatefulWidget {
  final TextEditingController controller;
  const TransactionDateTextForm({super.key, required this.controller});

  @override
  State<TransactionDateTextForm> createState() =>
      _TransactionDateTextFormState();
}

class _TransactionDateTextFormState extends State<TransactionDateTextForm> {
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
        readOnly: true, // prevent manual typing
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors
                            .primary, // header background + selected date
                        onPrimary: Colors.white, // text color on header
                        onSurface: AppColors.darkGrey, // default text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              AppColors.primary, // buttons like CANCEL / OK
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                setState(() {
                  widget.controller.text = DateFormat(
                    'MMM d, yyyy',
                  ).format(pickedDate);
                });
              }
            },
            icon: Icon(Icons.calendar_today_rounded, color: AppColors.darkGrey),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: "Transaction Date*",
          labelStyle: AppTextStyles.body1(
            color: AppColors.darkGrey,
            fontSize: 18,
          ),
          hintText: "yyyy-MM-dd",
          hintStyle: AppTextStyles.body1(
            color: AppColors.darkGrey,
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
          if (value == null || value.isEmpty) {
            return "Transaction date cannot be empty";
          }
          return null;
        },
      );
  }
}
