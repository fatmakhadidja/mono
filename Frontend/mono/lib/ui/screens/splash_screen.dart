import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [Color(0xff63B5AF), AppColors.primary],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'mono',
                style: AppTextStyles.heading1(color: AppColors.white),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
