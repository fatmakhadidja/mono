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
  final String fullName;

  final Function(Wallet) onWalletUpdated;

  HomePage({
    super.key,
    required this.transactions,
    required this.wallet,
    required this.fullName,

    required this.onWalletUpdated,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = AuthService();
  final WalletService walletService = WalletService();
  String? formattedDate;

  @override
  void initState() {
    super.initState();
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
                              widget.fullName,
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
                  balance: widget.wallet.balance,
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

        ...widget.transactions.map((tx) {
          // Parse tx.date ("yyyy-MM-dd") into DateTime
          final parsedDate = DateFormat('yyyy-MM-dd').parse(tx.date);
          // Format into dd MMM yyyy
          final formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);

          return TransactionRow(
            onDeleted: () {
              setState(() {
                walletService.deleteTransaction(tx.id, tx);
                widget.transactions.removeWhere((t) => t.id == tx.id);

                if (tx.income) {
                  widget.wallet.incomeAmount -= tx.amount;
                  widget.wallet.balance -= tx.amount;
                } else {
                  widget.wallet.expenseAmount -= tx.amount;
                  widget.wallet.balance += tx.amount;
                }

                widget.onWalletUpdated(widget.wallet);
              });
            },

            transaction: tx,
            id: tx.id,
            title: tx.name,
            date: formattedDate,
            amount: tx.amount,
            income: tx.income,
          );
        }).toList(),
      ],
    );
  }
}
