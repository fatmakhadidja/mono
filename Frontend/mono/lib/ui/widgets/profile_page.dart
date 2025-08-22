import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/profile_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatefulWidget {
  final Uint8List? profilePic; // Accept picture from HomeScreen

  const ProfilePage({super.key, this.profilePic});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String fullName;
  late String email;
  Uint8List? _profilePic;

  @override
  void initState() {
    super.initState();
    fullName = '';
    email = '';
    _profilePic = widget.profilePic; // Initialize from passed picture
    _loadFullName();
    _loadEmail();
  }

  Future<void> _loadFullName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('fullName') ?? '';
    if (mounted) {
      setState(() {
        fullName = savedName;
      });
    }
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email') ?? '';
    if (mounted) {
      setState(() {
        email = savedEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
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
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                      icon: const Icon(Icons.home_filled, color: Colors.white),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Profile",
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
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    backgroundImage: _profilePic != null
                        ? MemoryImage(_profilePic!)
                        : const AssetImage('assets/images/Profile.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  fullName,
                  style: AppTextStyles.body1(
                    color: AppColors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  email,
                  style: AppTextStyles.body1(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),
                ProfileRow(
                  widget: CircleAvatar(
                    backgroundColor: const Color(0xffF0F6F5),
                    radius: 30,
                    child: Image.asset('assets/images/diamond.png'),
                  ),
                  text: "Invite Friends",
                  onPressed: () {
                    const String inviteUrl = "https://www.google.com";
                    Share.share(
                      "Check out this amazing app! Download it here: $inviteUrl",
                      subject: "Join me on this app!",
                    );
                  },
                ),
                Divider(color: AppColors.lightLightGrey, thickness: 2),
                const SizedBox(height: 15),
                ProfileRow(
                  widget: const Icon(
                    Icons.person,
                    color: AppColors.darkGrey,
                    size: 30,
                  ),
                  text: "Change full name",
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      AppRoutes.changeFullName,
                    );
                    _loadFullName();
                  },
                ),
                const SizedBox(height: 15),
                ProfileRow(
                  widget: const Icon(
                    Icons.security,
                    color: AppColors.darkGrey,
                    size: 30,
                  ),
                  text: "Change password",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.changePassword);
                  },
                ),
                const SizedBox(height: 15),
                ProfileRow(
                  widget: const Icon(
                    Icons.logout,
                    color: AppColors.error,
                    size: 30,
                  ),
                  text: "Log out",
                  textColor: AppColors.error,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text("Log out"),
                          content: const Text(
                            "Are you sure you want to leave the app?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: AppColors.darkGrey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                AuthService().logout(context);
                              },
                              child: const Text(
                                "Log out",
                                style: TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
