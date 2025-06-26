import 'package:flutter/material.dart';
import 'package:ufad/Dashboard/dashbaord_drawer.dart';
import 'dashboard_metrics.dart';
import 'dashboard_filters.dart';
import 'dashboard_sales_chart.dart';
import 'dashboard_profile_card.dart';

const kGreen = Color(0xFF1BAEA6);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return Scaffold(
      drawer: DashboardDrawer(currentRoute: currentRoute),
      appBar: AppBar(
        backgroundColor: kGreen,
        title: const Text(
          'Ufad Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const DashboardBody(),
    );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DashboardMetrics(),
            SizedBox(height: 16),
            DashboardFilters(),
            SizedBox(height: 16),
            DashboardSalesChart(),
            SizedBox(height: 16),
            DashboardProfileCard(),
          ],
        ),
      ),
    );
  }
}
