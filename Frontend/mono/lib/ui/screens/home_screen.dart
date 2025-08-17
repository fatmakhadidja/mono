import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/services/WalletService.dart';
import 'package:mono/models/transaction.dart';
import 'package:mono/models/wallet.dart';
import 'package:mono/ui/widgets/home_page.dart';
import 'package:mono/ui/widgets/wallet_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fullname;
  final WalletService walletService = WalletService();

  late Wallet myWallet = Wallet(
    balance: 0.0,
    incomeAmount: 0.0,
    expenseAmount: 0.0,
    transactions: [],
  );

  List<Transaction> transactions = [];
  int navIndex = 0;
  String formattedDate = '';

  Future<void> loadFullname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullname = prefs.getString('fullName');
      print("here is fullname in home $fullname");
    });
  }

  @override
  void initState() {
    super.initState();
    loadFullname();

    walletService.getWalletInfo().then((wallet) {
      if (wallet != null) {
        setState(() {
          myWallet = wallet;
          transactions = wallet.transactions;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        fullname: fullname ?? '',
        transactions: transactions,
        wallet: myWallet,
      ),
     Center(child: Text("Statistics Page")),
      WalletPage(),
      Center(child: Text("Profile Page")),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[navIndex],
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Container(
              decoration: BoxDecoration(
                color: navIndex == 3
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/icons/user.svg",
                width: 24,
                height: 24,
                color: navIndex == 3 ? AppColors.primary : AppColors.darkGrey,
              ),
            ),
            label: "",
          ),
        ],
        currentIndex: navIndex,
      ),
    );
  }
}
