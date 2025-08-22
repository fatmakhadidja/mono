import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';

class DailyLineChart extends StatelessWidget {
  final List<double> dailyData; // values per day
  final int daysInMonth;

  const DailyLineChart({
    super.key,
    required this.dailyData,
    required this.daysInMonth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          minX: 1,
          maxX: daysInMonth.toDouble(),
          minY: 0,
          maxY: dailyData.isEmpty
              ? 10
              : (dailyData.reduce((a, b) => a > b ? a : b)) + 10,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text("${value.toInt()}");
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5, // step of 5
                getTitlesWidget: (value, meta) {
                  // show only multiples of 5
                  if (value % 5 == 0 && value <= daysInMonth) {
                    return Text("${value.toInt()}");
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < dailyData.length; i++)
                  FlSpot((i + 1).toDouble(), dailyData[i]),
              ],
              isCurved: true,
              curveSmoothness: 0.2,
              color: AppColors.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    "Day ${spot.x.toInt()}\n${spot.y.toStringAsFixed(2)} DZD",
                    const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
