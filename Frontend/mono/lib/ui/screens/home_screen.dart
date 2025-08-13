import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:mono/models/transaction.dart';
import 'package:mono/models/wallet.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/transaction_row.dart';
import 'package:mono/ui/widgets/wallet_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fullname;
  final AuthService authService = AuthService();

  Future<void> _loadFullname() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullname = prefs.getString('fullname');
    });
  }

  late Wallet myWallet;

  List<Transaction> transactions = [
    Transaction(title: "upwork", amount: 2500, income: true, date: "yesterday"),
    Transaction(title: "upwork", amount: 2500, income: true, date: "yesterday"),
    Transaction(title: "upwork", amount: 3000, income: true, date: "last week"),
    Transaction(
      title: "upwork",
      amount: 2000,
      income: false,
      date: "last month",
    ),
    Transaction(
      title: "upwork",
      amount: 2000,
      income: false,
      date: "last month",
    ),
    Transaction(
      title: "upwork",
      amount: 2000,
      income: false,
      date: "last month",
    ),
    Transaction(
      title: "upwork",
      amount: 2000,
      income: false,
      date: "last month",
    ),
  ];

  int navIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFullname();

    myWallet = Wallet(
      balance: 200000,
      transactions: transactions,
      incomeAmount: 2000,
      expenseAmount: 500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Stack(
                children: [
                  CurvedTop(
                    screenHeight: MediaQuery.of(context).size.height,
                    screenWidth: MediaQuery.of(context).size.width,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back,",
                                style: AppTextStyles.body1(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "$fullname",
                                style: AppTextStyles.heading1(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () {
                                authService.logout(context);
                              },
                              icon: Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: WalletContainer(
                    balance: myWallet.balance,
                    incomeAmount: myWallet.incomeAmount,
                    expenseAmount: myWallet.expenseAmount,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transaction History",
                  style: AppTextStyles.heading1(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: AppTextStyles.body1(
                      color: AppColors.darkGrey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ...transactions
              .map(
                (tx) => TransactionRow(
                  title: tx.title,
                  date: tx.date,
                  amount: tx.amount,
                ),
              )
              .toList(),
        ],
      ),
      bottomNavigationBar:  Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              )
            ]
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
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
                icon: Icon(
                  Icons.add,
                  size: 30,
                  color: navIndex == 2 ? AppColors.primary : AppColors.darkGrey,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/user.svg",
                  width: 24,
                  height: 24,
                  color: navIndex == 2 ? AppColors.primary : AppColors.darkGrey,
                ),
                label: "",
              ),
            ],
            currentIndex: navIndex,
          ),
        ),
      
    );
  }
}
