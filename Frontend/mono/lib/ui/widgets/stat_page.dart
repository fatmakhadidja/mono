import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mono/core/constants/colors.dart';
import 'package:mono/core/constants/text_styles.dart';
import 'package:mono/models/transaction.dart';
import 'package:mono/routes/routes.dart';
import 'package:mono/ui/widgets/daily_line_chart.dart';
import 'package:mono/ui/widgets/transaction_row.dart';

class StatPage extends StatefulWidget {
  final List<Transaction> transactions;

  const StatPage({super.key, required this.transactions});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  final List<String> months = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  late String selectedMonth;
  late int selectedYear = DateTime.now().year;
  bool showIncome = false; // 🔹 toggle for filter button

  @override
  void initState() {
    super.initState();
    selectedMonth = DateFormat('MMMM').format(DateTime.now());
    selectedYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = widget.transactions.where((tx) {
      try {
        final parsedDate = DateFormat('yyyy-MM-dd').parse(tx.date);
        final txMonth = DateFormat('MMMM').format(parsedDate);
        return txMonth == selectedMonth && parsedDate.year == selectedYear;
      } catch (e) {
        debugPrint("Invalid date format: ${tx.date}");
        return false;
      }
    }).toList();

    // 🔹 Group expenses by day for chart
    final monthIndex = months.indexOf(selectedMonth) + 1;
    final daysInMonth = DateUtils.getDaysInMonth(selectedYear, monthIndex);

    List<double> dailyExpenses = List.filled(daysInMonth, 0);
    List<double> dailyIncomes = List.filled(daysInMonth, 0);

    for (var tx in filteredTransactions) {
      try {
        final parsedDate = DateFormat('yyyy-MM-dd').parse(tx.date);
        if (tx.income) {
          dailyIncomes[parsedDate.day - 1] += tx.amount;
        } else {
          dailyExpenses[parsedDate.day - 1] += tx.amount;
        }
      } catch (e) {
        debugPrint("Skipping invalid date: ${tx.date}");
      }
    }

    // 🔹 Top 3 Expenses
    final topSpending = filteredTransactions.where((tx) => !tx.income).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final top3Spending = topSpending.take(3).toList();

    // 🔹 Top 3 Incomes
    final topIncomes = filteredTransactions.where((tx) => tx.income).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final top3Incomes = topIncomes.take(3).toList();

    final topList = showIncome ? top3Incomes : top3Spending;

    // 🔹 Generate last 5 years list (you can expand)
    final years = List<int>.generate(2, (i) => DateTime.now().year - i);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 🔹 AppBar
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    },
                    icon: const Icon(Icons.home_filled, color: Colors.black),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Statistics",
                        style: AppTextStyles.body1(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // 🔹 Month + Year dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Year Dropdown
                  DropdownButton<int>(
                    value: selectedYear,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 14,
                    ),
                    underline: Container(height: 2, color: AppColors.primary),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items: years.map<DropdownMenuItem<int>>((int year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 10),

                  // Month Dropdown
                  DropdownButton<String>(
                    value: selectedMonth,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 14,
                    ),
                    underline: Container(height: 2, color: AppColors.primary),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                      });
                    },
                    items: months.map<DropdownMenuItem<String>>((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(height: 15),
              // 🔹 Daily Expense Chart
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: DailyLineChart(
                  dailyData: showIncome ? dailyIncomes : dailyExpenses,
                  daysInMonth: daysInMonth,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Top Spending / Top Incomes Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    showIncome ? "Top Incomes" : "Top Spending",
                    style: AppTextStyles.heading1(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showIncome = !showIncome; // 🔹 toggle list
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/filter.svg',
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),

              // 🔹 Transactions List (Top 3)
              Expanded(
                child: ListView.builder(
                  itemCount: topList.length,
                  itemBuilder: (context, index) {
                    final tx = topList[index];
                    final parsedDate = DateFormat('yyyy-MM-dd').parse(tx.date);
                    return TransactionRow(
                      onDeleted: () {},
                      id: tx.id,
                      title: tx.name,
                      date: DateFormat('dd MMM yyyy').format(parsedDate),
                      amount: tx.amount,
                      income: tx.income,
                      transaction: tx,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
