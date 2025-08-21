import 'package:flutter/material.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/ProfileService.dart';
import 'package:mono/ui/widgets/confirm_password_text_form.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:mono/ui/widgets/password_text_form.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final Profileservice profileservice = Profileservice();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>(); // 🔹 form key
  bool _isLoading = false;

  Future<void> _handleSave() async {
  if (!_formKey.currentState!.validate()) return; // 🔹 validate before submit

  setState(() => _isLoading = true);

  final result = await profileservice.changePassword(
    currentPasswordController.text,
    newPasswordController.text,
  );

  if (mounted) {
    setState(() => _isLoading = false);

    if (result == null) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );
      Navigator.pop(context); // go back only if success
    } else if (result == "Current password is incorrect") {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Current password is incorrect")),
      );
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }
}


  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CurvedTop(screenHeight: screenHeight, screenWidth: screenWidth),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
              child: Form(
                key: _formKey, // 🔹 wrap inside a Form
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Change password",
                              style: AppTextStyles.body1(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Current password
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: PasswordTextForm(
                        controller: currentPasswordController,
                        label: 'Current Password',
                      ),
                    ),

                    // New password
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: PasswordTextForm(
                        controller: newPasswordController,
                        label: 'New Password',
                      ),
                    ),

                    // Confirm new password
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: ConfirmPasswordTextForm(
                        controller: confirmPasswordController,
                        label: 'Confirm new password',
                        firstPassword: newPasswordController,
                      ),
                    ),

                    const Spacer(),
                    MyFilledButton(
                      onPressed: _isLoading ? null : _handleSave,
                      text: "Save changes",
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
