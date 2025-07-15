// 📁 lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/models/dashboard_model.dart';
import 'package:ufad/providers/dashboard_provider.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/widgets/loader.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        if (auth.user != null) {
          final userId = auth.user!.id;
          Provider.of<DashboardProvider>(
            context,
            listen: false,
          ).fetchDashboard(userId);
        }
      });
    }
  }

  Future<void> _refreshDashboard() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user != null) {
      await Provider.of<DashboardProvider>(
        context,
        listen: false,
      ).fetchDashboard(auth.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, AuthProvider>(
      builder: (context, provider, auth, _) {
        if (auth.user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.loading) return const Loader();

        if (provider.error != null) {
          return Scaffold(
            body: Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final data = provider.dashboard;
        final businessName = auth.business?.name ?? 'User';

        if (data == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Dashboard'),
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshDashboard,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refreshDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $businessName',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  _buildSummaryCard('Total Sales', data.totalSales),
                  _buildSummaryCard('Total Expenses', data.totalExpenses),
                  _buildSummaryCard('Profit', data.totalProfit),
                  _buildSummaryCard('Credit Score', data.creditScore),
                  const SizedBox(height: 20),
                  Text(
                    'Sales Trend',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildChart(data.salesTrend),
                  const SizedBox(height: 24),
                  Text(
                    'Top Debtors',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...data.topDebtors.map(
                    (d) => ListTile(
                      title: Text(d.name),
                      trailing: Text('₵${d.amount.toStringAsFixed(2)}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, dynamic value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            value is double ? '₵${value.toStringAsFixed(2)}' : value.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<SalesTrend> trends) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= trends.length) {
                    return const Text('');
                  }
                  return Text(
                    trends[index].month,
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true),
              spots:
                  trends
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.total))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
