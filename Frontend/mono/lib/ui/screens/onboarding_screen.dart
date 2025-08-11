import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/custom_rectangle_onboarding.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 0.6,
                  ),
                  painter: CustomRectangle(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: Image.asset('assets/images/onboarding_guy.png'),
                ),
              ],
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "spend smarter, save more",
                style: AppTextStyles.heading1(
                  color: AppColors.primary,
                  fontSize: 36,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: MyFilledButton(onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.register);
              }, text: "Get Started"),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have An Account?",
                  style: AppTextStyles.body1(
                    color: AppColors.darkGrey,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    "Log In",
                    style: AppTextStyles.body1(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
