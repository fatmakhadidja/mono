import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/ui/screens/login_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait 2 seconds, then go to login page
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('mono', style: AppTextStyles.heading1(color: AppColors.white)),
            SizedBox(height: 15),
            SizedBox(
              height: 50,
              width: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.lineScaleParty,

                colors: const [
                  AppColors.darkGrey,
                  AppColors.lightGrey,
                  Color(0xff429690),
                ],

                /// Optional, The color collections
                strokeWidth: 2,

                pathBackgroundColor: Colors.black,

                /// Optional, the stroke backgroundColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
