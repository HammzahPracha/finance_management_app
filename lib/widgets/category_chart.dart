import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction_model.dart';

class CategoryChart extends StatelessWidget {
  final Map<String, double> categoryData;
  final TransactionType type;
  final List<Color> colors;

  const CategoryChart({
    super.key,
    required this.categoryData,
    required this.type,
    this.colors = const [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
      Color(0xFF3B82F6),
      Color(0xFFEF4444),
    ],
  });

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    final entries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return PieChart(
      PieChartData(
        sections: _buildSections(entries),
        centerSpaceRadius: 60,
        sectionsSpace: 2,
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
      List<MapEntry<String, double>> entries) {
    final total = entries.fold(0.0, (sum, entry) => sum + entry.value);

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final percentage = (data.value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value,
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
