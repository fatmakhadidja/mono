import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class MyFilledButton extends StatelessWidget {
  final String text;
  const MyFilledButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primary),
        shadowColor: WidgetStatePropertyAll(
          Colors.black.withOpacity(0.5),
        ), 
        elevation: WidgetStatePropertyAll(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text,
          style: AppTextStyles.body1(color: AppColors.white, fontSize: 18),
        ),
      ),
    );
  }
}
