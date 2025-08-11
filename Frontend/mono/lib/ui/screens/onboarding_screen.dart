import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/ui/widgets/custom_rectangle_onboarding.dart';
import 'package:mono/ui/widgets/filled_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
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
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 20),
                child: Image.asset('assets/images/onboarding_guy.png'),
              ),
            ],
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              "spend smarter save more",
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
            child: MyFilledButton(text: "Get Started"),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have account?",
                style: AppTextStyles.body1(
                  color: AppColors.darkGrey,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {},
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
    );
  }
}
