import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/core/services/WalletService.dart';
import 'package:mono/models/transaction.dart';

class TransactionRow extends StatefulWidget {
  final int id;
  final String? title;
  final String? date;
  final double? amount;
  final bool income;
  final Transaction transaction;
  final VoidCallback? onDeleted;
  const TransactionRow({
    super.key,
    required this.onDeleted,
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.income,
    required this.transaction,
  });

  @override
  State<TransactionRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<TransactionRow> {
  WalletService walletService = WalletService();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,

              title: Text("Transaction Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Title:  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: widget.title),
                      ],
                    ),
                  ),

                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Date:  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: widget.date),
                      ],
                    ),
                  ),

                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Amount:  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: widget.amount.toString()),
                      ],
                    ),
                  ),

                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Type:  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: widget.income ? "Income" : "Expense"),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await walletService.deleteTransaction(
                      widget.id,
                      widget.transaction,
                    );
                    if (widget.onDeleted != null) {
                      widget.onDeleted!(); 
                    }
                    Navigator.pop(context); 
                  },
                  child: Text(
                    "Delete transaction",
                    style: AppTextStyles.body1(
                      color: AppColors.error,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xffF0F6F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  "assets/images/wallet_with_cash.png",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title ?? "",
                    style: AppTextStyles.heading1(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    widget.date ?? "",
                    style: AppTextStyles.body1(
                      color: AppColors.darkGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            widget.income ? '+ ${widget.amount} DZD' : '- ${widget.amount} DZD',
            style: AppTextStyles.heading1(
              color: widget.income ? AppColors.success : AppColors.error,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
