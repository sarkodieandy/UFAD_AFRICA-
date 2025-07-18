import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/models/dashboard_model.dart';
import 'package:ufad/models/business_profile.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/providers/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _initialized = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        if (auth.user != null) {
          Provider.of<DashboardProvider>(
            context,
            listen: false,
          ).fetchDashboard(auth.user!.id);
          _controller.forward();
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
        if (provider.loading || auth.user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final DashboardModel data =
            provider.dashboard ?? DashboardModel.empty();
        final BusinessProfile? business = auth.business;

        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F5),
          appBar: AppBar(
            title: const Text('📊 Dashboard Overview'),
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshDashboard,
              ),
            ],
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: RefreshIndicator(
              onRefresh: _refreshDashboard,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeader(data, business),
                  const SizedBox(height: 16),
                  _buildMetricsGrid(data),
                  const SizedBox(height: 24),
                  _buildChartSection(data.salesTrend),
                  const SizedBox(height: 24),
                  _buildTopDebtorsSection(data.topDebtors),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(DashboardModel data, BusinessProfile? business) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage:
                  business?.profileImage.isNotEmpty == true
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
                    data.businessName.isNotEmpty
                        ? data.businessName
                        : 'Business Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📍 ${data.businessLocation.isNotEmpty ? data.businessLocation : "N/A"}',
                  ),
                  Text(
                    '📞 ${data.businessPhone.isNotEmpty ? data.businessPhone : "N/A"}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(DashboardModel data) {
    final items = [
      ('Total Sales', data.totalSales, Icons.attach_money),
      ('Total Expenses', data.totalExpenses, Icons.money_off),
      ('Profit', data.totalProfit, Icons.trending_up),
      ('Unpaid Sales', data.unpaidSales, Icons.money),
      ('Credit Score', '${data.creditScore} (${data.creditTier})', Icons.score),
      ('Loan Qual.', data.loanQualification, Icons.check_circle),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          items
              .map((item) => _buildMetricCard(item.$1, item.$2, item.$3))
              .toList(),
    );
  }

  Widget _buildMetricCard(String label, dynamic value, IconData icon) {
    final isAmount = value is double;
    final displayValue =
        isAmount ? '₵${value.toStringAsFixed(2)}' : value.toString();

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: AppColors.green),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection(List<SalesTrend> trends) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📈 Sales Trend',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      int index = value.toInt();
                      return index >= 0 && index < trends.length
                          ? Text(
                            trends[index].month,
                            style: const TextStyle(fontSize: 10),
                          )
                          : const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              gridData: FlGridData(show: true),
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
        ),
      ],
    );
  }

  Widget _buildTopDebtorsSection(List<TopDebtor> debtors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📌 Top Debtors',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        debtors.isEmpty
            ? const Text('No top debtors yet.')
            : Column(
              children:
                  debtors
                      .map(
                        (debtor) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: Text(debtor.name),
                            trailing: Text(
                              '₵${debtor.amount.toStringAsFixed(2)}',
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
