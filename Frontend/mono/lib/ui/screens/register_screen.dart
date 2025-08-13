import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/custom_curved_shape.dart';
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

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false; // Loader state

  /// Register the user
  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true; // Show loader
    });

    bool success = await _authService.register(
      fullNameController.text.trim(),
      passwordController.text.trim(),
      emailController.text.trim(),
    );

    setState(() {
      _isLoading = false; // Hide loader
    });

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful!")));
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      ); // go to home after register
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration failed. Please try again.")),
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _handleRegister(); // Call with ()
                              }
                            },
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
