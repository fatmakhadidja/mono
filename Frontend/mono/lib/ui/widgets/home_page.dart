import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/WalletService.dart';
import 'package:mono/models/transaction.dart';
import 'package:mono/models/wallet.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/transaction_row.dart';
import 'package:mono/ui/widgets/wallet_container.dart';
import 'package:intl/intl.dart';
import 'package:mono/core/services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  List<Transaction> transactions;
  final Wallet wallet;

  HomePage({super.key, required this.transactions, required this.wallet});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = AuthService();
  final WalletService walletService = WalletService();
  String? formattedDate;
  double? balance;

  @override
  void initState() {
    super.initState();

    loadFullname();
    _loadWalletFromPrefs(); // load prefs asynchronously
  }

  Future<void> _loadWalletFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      balance = prefs.getDouble("balance");
      widget.wallet.incomeAmount = prefs.getDouble("incomeAmount") ?? 0.0;
      widget.wallet.expenseAmount = prefs.getDouble("expenseAmount") ?? 0.0;
    });
  }

  String? fullname;

  Future<void> loadFullname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullname = prefs.getString('fullName');
      print("here is fullname in home $fullname");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                              fullname ?? '',
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
                                          style: TextStyle(
                                            color: AppColors.darkGrey,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          AuthService().logout(context);
                                        },
                                        child: Text(
                                          "Log out",
                                          style: TextStyle(
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              
                            },
                            icon: const Icon(
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
                  balance: balance ?? 0.0,
                  incomeAmount: widget.wallet.incomeAmount,
                  expenseAmount: widget.wallet.expenseAmount,
                ),
              ),
            ),
          ],
        ),

        /// Transactions Section
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
                            primary: AppColors
                                .primary, // header background + selected date
                            onPrimary: Colors.white, // text color on header
                            onSurface: AppColors.darkGrey, // default text color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  AppColors.primary, // buttons like CANCEL / OK
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

                      widget.transactions = widget.wallet.transactions.where((
                        tx,
                      ) {
                        DateTime txDate = DateTime.parse(tx.date);

                        return DateFormat('yyyy-MM-dd').format(txDate) ==
                            formattedDate;
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

        ...(widget.transactions.isEmpty
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
            : widget.transactions
                  .map(
                    (tx) => TransactionRow(
                      onDeleted: () {
                        setState(() {
                          walletService.deleteTransaction(tx.id, tx);
                          widget.transactions.removeWhere((t) => t.id == tx.id);
                          _loadWalletFromPrefs();
                        });
                      },
                      transaction: tx,
                      id: tx.id,
                      title: tx.name,
                      date: tx.date,
                      amount: tx.amount,
                      income: tx.income,
                    ),
                  )
                  .toList()),
      ],
    );
  }
}
