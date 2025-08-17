import 'package:flutter/material.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/WalletService.dart';
import 'package:mono/models/transaction.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:mono/ui/widgets/transaction_container.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController transactionNameController = TextEditingController();
  TextEditingController transactionAmountController = TextEditingController();
  TextEditingController transactionDateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController transactionTypeController = TextEditingController(
    text: "Income",
  );

  WalletService walletService = WalletService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CurvedTop(
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
            child: Column(
              children: [
                // Header row
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                      icon: Icon(Icons.home_filled, color: Colors.white),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Add transaction",
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

                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TransactionContainer(
                          transactionNameController: transactionNameController,
                          transactionAmountController:
                              transactionAmountController,
                          transactionDateController: transactionDateController,
                          transactionTypeController: transactionTypeController,
                          formKey: formKey,
                        ),
                        SizedBox(height: 50),
                        MyFilledButton(
                          text: "Add New Transaction",
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final amountText = transactionAmountController
                                  .text
                                  .trim();
                              final amount = double.tryParse(amountText);
                              Transaction transaction = new Transaction(
                                amount: amount ?? 0.0,
                                name: transactionNameController.text,
                                income:
                                    transactionTypeController.text == "Income",
                                date: DateFormat('yyyy-MM-dd').format(
                                  DateTime.parse(
                                    transactionDateController.text,
                                  ),
                                ),
                              );
                              final result = await walletService.addTransaction(
                                transaction,
                              );
                              if (result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Transaction added successfully",
                                    ),
                                  ),
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.home,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to add transaction"),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
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
