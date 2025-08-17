import 'package:flutter/material.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/curved_top.dart';
import 'package:mono/ui/widgets/filled_button.dart';
import 'package:mono/ui/widgets/transaction_container.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                
                TransactionContainer(),
                MyFilledButton(text: "Add New Transaction", onPressed: () {})
              ],
            ),
          ),
        ),
      ],
    );
  }
}
