import 'package:flutter/material.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/ProfileService.dart';

import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:mono/ui/widgets/full_name_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeFullName extends StatefulWidget {
  const ChangeFullName({super.key});

  @override
  State<ChangeFullName> createState() => _ChangeFullNameState();
}

class _ChangeFullNameState extends State<ChangeFullName> {
  Profileservice profileservice = Profileservice();
  late TextEditingController controller;

  bool _isLoading = false; // 🔹 loading state

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _loadFullName();
  }

  Future<void> _loadFullName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('fullName') ?? '';
    setState(() {
      controller.text = savedName;
    });
  }

  Future<void> _saveFullName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', controller.text.trim());
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);

    await _saveFullName();
    await profileservice.changeFullname(controller.text);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    controller.dispose();
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
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Change full name",
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

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: FullNameForm(controller: controller),
                  ),

                  const Spacer(),
                  MyFilledButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            _handleSave();
                          },
                    text: "Save changes",
                  ),
                  const Spacer(),
                ],
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
