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
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    if (!hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      return;
    }

    // If onboarding has been seen, check if user is already logged in
    final fullname = prefs.getString('fullName');

    if (fullname != null && fullname.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
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
            const SizedBox(height: 15),
            const SizedBox(
              height: 50,
              width: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.lineScaleParty,
                colors: [
                  AppColors.darkGrey,
                  AppColors.lightGrey,
                  Color(0xff429690),
                ],
                strokeWidth: 2,
                pathBackgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
