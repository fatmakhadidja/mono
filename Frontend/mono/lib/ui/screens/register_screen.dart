import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/email_text_form.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:mono/ui/widgets/full_name_form.dart';
import 'package:mono/ui/widgets/password_text_form.dart';
import 'package:mono/ui/widgets/confirm_password_text_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final String? error = await _authService.register(
      fullNameController.text.trim(),
      passwordController.text.trim(),
      emailController.text.trim(),
    );

    if (!_isLoading) return;
    setState(() => _isLoading = false);

    if (error == null) {
      // Registration successful
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful!")));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      // Show error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    CurvedTop(
                      screenHeight: MediaQuery.of(context).size.height,
                      screenWidth: MediaQuery.of(context).size.width,
                    ),
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: Image.asset("assets/images/wallet_with_cash.png"),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        FullNameForm(controller: fullNameController),
                        const SizedBox(height: 25),
                        EmailTextForm(controller: emailController),
                        const SizedBox(height: 25),
                        PasswordTextForm(
                          label: "Password*",
                          controller: passwordController,
                        ),
                        const SizedBox(height: 25),
                        ConfirmPasswordTextForm(
                          label: "Confirm password*",
                          controller: confirmPasswordController,
                          firstPassword: passwordController,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: MyFilledButton(
                            onPressed: _handleRegister,
                            text: "Register",
                          ),
                        ),
                        const SizedBox(height: 5),
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
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
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
        ),
        if (_isLoading)
          GestureDetector(
            onTap: () {
              setState(() {
                _isLoading = false;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}
