import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mono/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();

    // Wait 2 seconds, then go to login page
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    if (hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else if (!hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
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
