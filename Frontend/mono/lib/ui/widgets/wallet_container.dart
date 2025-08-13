import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';

class WalletContainer extends StatefulWidget {
  final double balance;
  final double incomeAmount;
  final double expenseAmount;
  const WalletContainer({super.key, required this.balance, required this.incomeAmount, required this.expenseAmount});

  @override
  State<WalletContainer> createState() => _WalletContainerState();
}

class _WalletContainerState extends State<WalletContainer> {
  Widget IncomeExpense(Icon icon, String label) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            shape: BoxShape.circle,
          ),
          child: icon,
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: AppTextStyles.body1(color: Color(0xffD0E5E4), fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Color(0xff1A5854),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  "Total Balance",
                  style: AppTextStyles.heading1(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${widget.balance}",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IncomeExpense(
                      Icon(Icons.arrow_upward_rounded, color: Colors.white),
                      "Income",
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${widget.incomeAmount}DZD",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IncomeExpense(
                      Icon(Icons.arrow_downward_rounded, color: Colors.white),
                      "Expenses",
                    ),
                    SizedBox(height: 10),

                    Text(
                      "${widget.expenseAmount}DZD",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
