import 'package:flutter/material.dart';
import 'package:mono/ui/widgets/transaction_amount_text_form.dart';
import 'package:mono/ui/widgets/transaction_date_text_form.dart';
import 'package:mono/ui/widgets/transaction_name_text_form.dart';
import 'package:intl/intl.dart';
import 'package:mono/ui/widgets/transaction_type_text_form.dart';

class TransactionContainer extends StatefulWidget {
  const TransactionContainer({super.key});

  @override
  State<TransactionContainer> createState() => _TransactionContainerState();
}

class _TransactionContainerState extends State<TransactionContainer> {

   TextEditingController transactionNameController = TextEditingController();
   TextEditingController transactionAmountController = TextEditingController();
   TextEditingController transactionDateController = TextEditingController(text: DateFormat('dd MMM yyyy').format(DateTime.now()));
   TextEditingController transactionTypeController = TextEditingController(text :"Income");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5, 
      padding: EdgeInsets.all(20),
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
          
        ],  
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TransactionNameTextForm(controller: transactionNameController),
          TransactionAmountTextForm(controller: transactionAmountController),
          TransactionDateTextForm(controller: transactionDateController),
          TransactionTypeTextForm(controller: transactionTypeController),
        ],
      ),
    );
  }
}