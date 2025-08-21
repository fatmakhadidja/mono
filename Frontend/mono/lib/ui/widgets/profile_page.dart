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
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String fullName;
  late String email;

  @override
  void initState() {
    super.initState();
    fullName = '';
    email = '';
    _loadFullName();
    _loadEmail();
  }

  Future<void> _loadFullName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('fullName') ?? '';
    setState(() {
      fullName = savedName;
    });
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email') ?? '';
    setState(() {
      email = savedEmail;
    });
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

                // profile picture
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/Profile.png'),
                  ),
                ),

                // full name
                Text(
                  fullName,
                  style: AppTextStyles.body1(
                    color: AppColors.black,
                    fontSize: 16,
                  ),
                ),

                // email
                Text(
                  email,
                  style: AppTextStyles.body1(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),

                // invite friends row
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

                // change full name row
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

                    _loadFullName(); // reload only the full name after pop
                  },
                ),

                const SizedBox(height: 15),

                // change password row
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
                          title: Text("Log out"),
                          content: Text(
                            "Are you sure you want to leave the app?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: AppColors.darkGrey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                AuthService().logout(context);
                              },
                              child: Text(
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
