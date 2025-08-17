import 'package:flutter/material.dart';
import 'package:mono/core/constants/text_styles.dart';
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
  TextEditingController transactionNameController = TextEditingController();
  TextEditingController transactionAmountController = TextEditingController();
  TextEditingController transactionDateController = TextEditingController(
    text: DateFormat('dd MMM yyyy').format(DateTime.now()),
  );
  TextEditingController transactionTypeController = TextEditingController(
    text: "Income",
  );

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

                // 👇 acts like top spacing
                const Spacer(),

                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      children: [
                        TransactionContainer(
                          transactionNameController: transactionNameController,
                          transactionAmountController:
                              transactionAmountController,
                          transactionDateController: transactionDateController,
                          transactionTypeController: transactionTypeController,
                        ),
                       SizedBox(height: 50),
                        MyFilledButton(
                          text: "Add New Transaction",
                          onPressed: () {},
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
