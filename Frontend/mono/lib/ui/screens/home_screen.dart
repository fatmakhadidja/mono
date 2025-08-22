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
  Uint8List? _profilePic; // reactive profile picture

  @override
  void initState() {
    super.initState();
    _loadWallet();
    _loadProfilePic();
  }

  Future<void> _loadWallet() async {
    final wallet = await walletService.getWalletInfo();
    if (mounted) {
      setState(() {
        if (wallet != null) {
          myWallet = wallet;
          transactions = wallet.transactions;
        }
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

  void _updateProfilePic(Uint8List newPic) async {
      setState(() {
        _profilePic = newPic; // update UI immediately
      });
  
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(wallet: myWallet, transactions: myWallet.transactions),
      StatPage(transactions: myWallet.transactions),
      WalletPage(),
      ProfilePage(
        profilePic: _profilePic,
        onProfilePicChanged: _updateProfilePic,
      ), // pass callback
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
                    color: navIndex == 0
                        ? AppColors.primary
                        : AppColors.darkGrey,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/stat.svg",
                    width: 24,
                    height: 24,
                    color: navIndex == 1
                        ? AppColors.primary
                        : AppColors.darkGrey,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/wallet.svg",
                    width: 24,
                    height: 24,
                    color: navIndex == 2
                        ? AppColors.primary
                        : AppColors.darkGrey,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/user.svg",
                    width: 24,
                    height: 24,
                    color: navIndex == 3
                        ? AppColors.primary
                        : AppColors.darkGrey,
                  ),
                  label: "",
                ),
              ],
            ),
    );
  }
}
