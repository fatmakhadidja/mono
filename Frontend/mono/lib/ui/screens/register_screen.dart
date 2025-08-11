import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/ui/widgets/custom_curved_shape.dart';
import 'package:mono/ui/widgets/email_text_form.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:mono/ui/widgets/full_name_form.dart';
import 'package:mono/ui/widgets/password_text_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                    FullNameForm(),
                    SizedBox(height: 25),
                    EmailTextForm(),
                    SizedBox(height: 25),
                    PasswordTextForm(label: "Password*"),
                    SizedBox(height: 25),
                    PasswordTextForm(label: "Confirm password*"),
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
            ),
          ],
        ),
      ),
    );
  }
}
