import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'expense_model.dart';

class ChartsScreen extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const ChartsScreen({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ------------------------
            // 📊 PIE CHART
            // ------------------------
            const Text(
              "Category Breakdown",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: _getPieSections(expenses),
                  centerSpaceRadius: 40,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ------------------------
            // 📈 BAR CHART
            // ------------------------
            const Text(
              "Weekly Spending",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: _getBarGroups(expenses),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------
  // 📊 PIE DATA (CATEGORY WISE)
  // ------------------------
  List<PieChartSectionData> _getPieSections(
      List<ExpenseModel> expenses) {
    final Map<String, double> data = {};

    for (var e in expenses) {
      data[e.category] = (data[e.category] ?? 0) + e.amount;
    }

    return data.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        radius: 60,
      );
    }).toList();
  }

  // ------------------------
  // 📈 BAR DATA (WEEKLY)
  // ------------------------
  List<BarChartGroupData> _getBarGroups(
      List<ExpenseModel> expenses) {
    List<double> weekly = List.filled(7, 0);

    for (var e in expenses) {
      int day = e.date.weekday - 1;
      weekly[day] += e.amount;
    }

    return List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: weekly[i],
            width: 15,
          ),
        ],
      );
    });
  }
}