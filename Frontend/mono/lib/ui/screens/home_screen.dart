import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/services/ProfileService.dart';
import 'package:mono/core/services/WalletService.dart';
import 'package:mono/models/transaction.dart';
import 'package:mono/models/wallet.dart';
import 'package:mono/ui/widgets/home_page.dart';
import 'package:mono/ui/widgets/home_skeleton.dart';
import 'package:mono/ui/widgets/profile_page.dart';
import 'package:mono/ui/widgets/stat_page.dart';
import 'package:mono/ui/widgets/wallet_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WalletService walletService = WalletService();

  Wallet myWallet = Wallet(
    balance: 0.0,
    incomeAmount: 0.0,
    expenseAmount: 0.0,
    transactions: [],
  );
  List<Transaction> transactions = [];
  int navIndex = 0;
  bool _isLoading = true;
  Uint8List? _profilePic;
  String fullname = '';
  String email = '';
  double balance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
    _loadProfilePic();
  }

  Future<void> _loadHomeData() async {
    final wallet = await walletService.getWalletInfo();
    final prefs = await SharedPreferences.getInstance();
    final savedFullname = prefs.getString('fullName') ?? '';
    final savedEmail = prefs.getString('email') ?? '';
    final savedBalance = prefs.getDouble('balance') ?? 0.0;

    if (mounted) {
      setState(() {
        if (wallet != null) {
          myWallet = wallet;
          transactions = wallet.transactions;
        }
        fullname = savedFullname;
        email = savedEmail;
        balance = savedBalance;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProfilePic() async {
    final service = Profileservice();
    final pic = await service.getProfilePic();
    if (mounted) {
      setState(() {
        _profilePic = pic;
      });
    }
  }

  void _updateProfilePic(Uint8List newPic) {
    setState(() {
      _profilePic = newPic;
    });
  }

 void _updateFullName(String newName) {
  setState(() {
    fullname = newName;
  });
}

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        wallet: myWallet,
        transactions: transactions,
        fullName: fullname,
       
        onWalletUpdated: (updatedWallet) {
          setState(() {
            myWallet = updatedWallet;
          });
        },
      ),
      StatPage(transactions: transactions),
      WalletPage(),
      ProfilePage(
        profilePic: _profilePic,
        fullName: fullname,
        email: email,
        onProfilePicChanged: _updateProfilePic,
        onFullNameChanged: _updateFullName,
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: _isLoading ? const HomeSkeleton() : pages[navIndex],
      bottomNavigationBar: _isLoading
          ? null
          : BottomNavigationBar(
              elevation: 20,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) => setState(() => navIndex = index),
              currentIndex: navIndex,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/home.svg",
                    width: 24,
                    height: 24,
                    color: navIndex == 0 ? AppColors.primary : AppColors.darkGrey,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/stat.svg",
                    width: 24,
                    height: 24,
                    color: navIndex == 1 ? AppColors.primary : AppColors.darkGrey,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/wallet.svg",
                    width: 24,
                    height: 24,
                    color: navIndex == 2 ? AppColors.primary : AppColors.darkGrey,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/user.svg",
                    width: 24,
                    height: 24,
                    color: navIndex == 3 ? AppColors.primary : AppColors.darkGrey,
                  ),
                  label: "",
                ),
              ],
            ),
    );
  }
}
