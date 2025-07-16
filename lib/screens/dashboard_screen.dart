import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/models/business_profile.dart';
import 'package:ufad/models/dashboard_model.dart';
import 'package:ufad/providers/dashboard_provider.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
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
        if (auth.user == null || provider.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

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

        final data = provider.dashboard!;
        final business = auth.business;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FB),
          appBar: AppBar(
            title: const Text(''),
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
                  _buildHeaderCard(
                    data,
                    business,
                  ).animate().fade(duration: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildSummaryCard(
                        'Total Sales',
                        data.totalSales,
                        Icons.attach_money,
                      ),
                      _buildSummaryCard(
                        'Expenses',
                        data.totalExpenses,
                        Icons.money_off,
                      ),
                      _buildSummaryCard(
                        'Profit',
                        data.totalProfit,
                        Icons.trending_up,
                      ),
                      _buildSummaryCard(
                        'Unpaid',
                        data.unpaidSales,
                        Icons.money,
                      ),
                      _buildSummaryCard(
                        'Credit Score',
                        '${data.creditScore} (${data.creditTier})',
                        Icons.score,
                      ),
                      _buildSummaryCard(
                        'Loan Qual.',
                        data.loanQualification,
                        Icons.check_circle_outline,
                      ),
                    ],
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),
                  const SizedBox(height: 24),
                  Text(
                    '📈 Sales Trend',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildChart(
                    data.salesTrend,
                  ).animate().fade(duration: 400.ms).slideX(begin: 0.1),
                  const SizedBox(height: 24),
                  Text(
                    '📌 Top Debtors',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (data.topDebtors.isEmpty)
                    const Text('No top debtors yet.')
                  else
                    Column(
                      children:
                          data.topDebtors
                              .map(
                                (d) => ListTile(
                                  leading: const Icon(Icons.person_outline),
                                  title: Text(d.name),
                                  trailing: Text(
                                    '₵${d.amount.toStringAsFixed(2)}',
                                  ),
                                ),
                              )
                              .toList(),
                    ).animate().fadeIn(duration: 400.ms),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(DashboardModel data, BusinessProfile? business) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.green.withOpacity(0.1),
            backgroundImage:
                (business?.profileImage.isNotEmpty == true)
                    ? NetworkImage(business!.profileImage)
                    : const AssetImage('assets/avatar_placeholder.jpg')
                        as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.businessName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(data.businessLocation),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(data.businessPhone),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, dynamic value, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.green.withOpacity(0.15), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.green),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            value is double ? '₵${value.toStringAsFixed(2)}' : value.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  return index >= 0 && index < trends.length
                      ? Text(
                        trends[index].month,
                        style: const TextStyle(fontSize: 10),
                      )
                      : const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: AppColors.green,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.green.withOpacity(0.2),
              ),
              dotData: FlDotData(show: false),
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
