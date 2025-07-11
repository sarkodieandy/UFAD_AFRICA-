import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_colors.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Animate chart in
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-40 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 1.4, // Less wide for better fit on mobile
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text('Jun 2025', style: TextStyle(fontSize: 10)),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: TextStyle(fontSize: 10)),
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: 1,
            minY: 0,
            maxY: 40000,
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 38000),
                  FlSpot(1, 38000),
                ],
                isCurved: true,
                color: AppColors.green500,
                barWidth: 4,
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.green500.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
