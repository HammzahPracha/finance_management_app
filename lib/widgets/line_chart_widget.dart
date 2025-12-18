import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class LineChartWidget extends StatelessWidget {
  final List<TransactionModel> transactions;
  final TransactionType type;

  const LineChartWidget({
    super.key,
    required this.transactions,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = transactions
        .where((t) => t.type == type)
        .toList();

    if (filteredTransactions.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    // Group by date
    final Map<DateTime, double> dailyTotals = {};
    for (var transaction in filteredTransactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      dailyTotals[date] = (dailyTotals[date] ?? 0) + transaction.amount;
    }

    final sortedDates = dailyTotals.keys.toList()..sort();
    final spots = sortedDates.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), dailyTotals[entry.value]!);
    }).toList();

    final color = type == TransactionType.income
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: sortedDates.length > 7 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedDates.length) return const Text('');
                final date = sortedDates[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('MMM dd').format(date),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        minX: 0,
        maxX: (sortedDates.length - 1).toDouble(),
        minY: 0,
        maxY: dailyTotals.values.reduce((a, b) => a > b ? a : b) * 1.2,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

