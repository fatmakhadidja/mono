import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/ui/widgets/custom_curved_shape.dart';
import 'package:mono/ui/widgets/email_text_form.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:mono/ui/widgets/password_text_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Stack(
                  children: [
                    CustomPaint(
                      size: Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * 0.4,
                      ),
                      painter: CustomCurvedShape(),
                    ),
                    Image.asset("assets/images/login_shapes.png"),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: Image.asset("assets/images/wallet_with_cash.png"),
                ),
              ],
            ),

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  children: [
                    EmailTextForm(),
                    SizedBox(height: 25),
                    PasswordTextForm(label: "Password*"),
                    SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: MyFilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print("Form submitted");
                          }
                        },
                        text: "Log In",
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have An Account?",
                          style: AppTextStyles.body1(
                            color: AppColors.darkGrey,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/register',
                            );
                          },
                          child: Text(
                            "Register",
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
            ),
          ],
        ),
      ),
    );
  }
}
