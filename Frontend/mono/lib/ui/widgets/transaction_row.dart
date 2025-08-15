import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/main.dart';

class TransactionRow extends StatefulWidget {
  
  final String? title;
  final String? date;
  final double? amount;
  final bool income;
  const TransactionRow({super.key, required this.title, required this.date, required this.amount, required this.income});

  @override
  State<TransactionRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<TransactionRow> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
            widget.income ? 
            '+ ${widget.amount} DZD' :
            '- ${widget.amount} DZD',
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
