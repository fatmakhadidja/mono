import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:mono/core/services/ProfileService.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/profile_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatefulWidget {
  final Uint8List? profilePic; // initial picture from HomeScreen
  final Function(String) onFullNameChanged;
  String fullName;
  final String email;
  final Function(Uint8List) onProfilePicChanged; // callback to update parent

  ProfilePage({
    super.key,
    this.profilePic,
    required this.onProfilePicChanged,
    required this.onFullNameChanged,
    required this.fullName,
    required this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _profilePic;

  @override
  void initState() {
    super.initState();

    _profilePic = widget.profilePic;
  }

  void _loadFullName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('fullName') ?? '';
    if (mounted) {
      setState(() {
        widget.fullName = savedName;
      });
      widget.onFullNameChanged(savedName); 
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();

      // Call backend to update picture
      final profileService = Profileservice();
      final String? error = await profileService.changeProfilePicture(bytes);

      if (error == null) {
        setState(() {
          _profilePic = bytes;
        });
        widget.onProfilePicChanged(bytes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile picture updated successfully!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile picture: $error")),
        );
      }
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
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.blueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(3), // border thickness
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: _profilePic != null
                              ? MemoryImage(_profilePic!)
                              : const AssetImage('assets/images/Profile.png')
                                    as ImageProvider,
                          child: _profilePic == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.black54,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.fullName,
                  style: AppTextStyles.body1(
                    color: AppColors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.email,
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
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: AppColors.darkGrey),
                              ),
                            ),
                            TextButton(
                              onPressed: () => AuthService().logout(context),
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
