import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/email_text_form.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:mono/ui/widgets/password_text_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final String? result = await _authService.authenticate(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!_isLoading) return;
    setState(() => _isLoading = false);

    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful!")));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == "Invalid credentials"
                ? "Login failed. Please check your credentials."
                : result,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    

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
                        EmailTextForm(controller: _emailController),
                        const SizedBox(height: 25),
                        PasswordTextForm(
                          label: "Password*",
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: screenWidth * 0.8,
                          child: MyFilledButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _handleLogin();
                              }
                            },
                            text: "Log In",
                          ),
                        ),
                        const SizedBox(height: 5),
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
        ),
        if (_isLoading)
          GestureDetector(
            onTap: () {
              setState(() {
                _isLoading = false;
              });
              return;
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
