import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:mono/core/services/WalletService.dart';
import 'package:mono/models/transaction.dart';
import 'package:mono/models/wallet.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/transaction_row.dart';
import 'package:mono/ui/widgets/wallet_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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

  late Wallet myWallet = Wallet(
    balance: 1.0,
    incomeAmount: 11.0,
    expenseAmount: 11.0,
    transactions: [],
  );
  final WalletService walletService = WalletService();

  List<Transaction> transactions = [];

  int navIndex = 0;
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    _loadFullname();

    walletService.getWalletInfo().then((wallet) {
      print("Fetched wallet: $wallet");

      if (wallet != null) {
        setState(() {
          myWallet = wallet;

          transactions = wallet.transactions;

          print("Fetched transactions: ${wallet.transactions}");
        });
      }
    });
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
                IconButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary:
                                  AppColors.primary, // header background color
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.teal, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      setState(() {
                        formattedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(pickedDate);
                        transactions = myWallet.transactions.where((tx) {
                          return tx.date == formattedDate;
                        }).toList();
                      });
                    }
                  },
                  icon: Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),

          ...(transactions.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        "No transactions yet",
                        style: AppTextStyles.body1(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ]
              : transactions
                    .map(
                      (tx) => TransactionRow(
                        title: tx.title,
                        date: tx.date,
                        amount: tx.amount,
                        income: tx.income,
                      ),
                    )
                    .toList()),
        ],
      ),
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
