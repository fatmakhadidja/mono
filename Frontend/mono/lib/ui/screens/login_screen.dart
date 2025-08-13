import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:mono/routes/routes.dart';
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
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool _isLoading = false;

  /// Handle login
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    bool success = await _authService.authenticate(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful!")));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed. Please check your credentials."),
        ),
      );
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
                    CustomPaint(
                      size: Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * 0.4,
                      ),
                      painter: CustomCurvedShape(),
                    ),
                    Image.asset("assets/images/login_shapes.png"),
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
                        EmailTextForm(controller: emailController),
                        const SizedBox(height: 25),
                        PasswordTextForm(
                          label: "Password*",
                          controller: passwordController,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
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
        if (_isLoading) // Loader overlay
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _isLoading = false; // Stop loading on tap
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
