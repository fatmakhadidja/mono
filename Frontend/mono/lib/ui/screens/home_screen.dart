import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
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
  String formattedDate = '';

  bool _isLoading = true; // 🔹 Track loading state

  @override
  void initState() {
    super.initState();
    _loadWallet();
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(wallet: myWallet, transactions: myWallet.transactions),
      StatPage(transactions: myWallet.transactions),
      const WalletPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: _isLoading ? const HomeSkeleton() : pages[navIndex],
      bottomNavigationBar: _isLoading
          ? null // 🔹 hide navbar while loading
          : BottomNavigationBar(
              elevation: 20,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) {
                setState(() {
                  navIndex = index;
                });
              },
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
              currentIndex: navIndex,
            ),
    );
  }
}
