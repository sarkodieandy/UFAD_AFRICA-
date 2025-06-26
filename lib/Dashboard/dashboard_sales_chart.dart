import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

const kGreen = Color(0xFF21C087);

class DashboardSalesChart extends StatelessWidget {
  const DashboardSalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Trend',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 1.5),
                        FlSpot(2, 1.2),
                        FlSpot(3, 2.2),
                        FlSpot(4, 1.8),
                        FlSpot(5, 2.8),
                        FlSpot(6, 2.2),
                      ],
                      isCurved: true,
                      barWidth: 3,
                      color: kGreen,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
