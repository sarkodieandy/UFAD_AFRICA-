import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/dashboad/widget/activity_list.dart';
import 'package:ufad/dashboad/model/busines_profile_model.dart';
import 'package:ufad/dashboad/profile_modal.dart';
import 'package:ufad/dashboad/utils/styles.dart';
import 'package:ufad/dashboad/widget/chart_widget.dart';
import 'package:ufad/dashboad/widget/custom_drawer.dart';
import 'package:ufad/dashboad/widget/metric_card.dart';
import 'package:ufad/dashboad/widget/profile_card.dart';
import 'package:ufad/dashboad/widget/search_widget.dart';
import 'package:ufad/provider/dashboard_provider.dart';
import 'package:ufad/provider/user_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    final businessProfile = BusinessProfile(
      userProvider.businessName,
      userProvider.phone,
      userProvider.location,
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: Text(
            '${userProvider.businessName} Dashboard',
            style: Styles.appBarTextStyle,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () => _showUserMenu(context),
            ),
          ],
        ),
        body: dashboardProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchWidget(),
                    const SizedBox(height: 16),
                    Text('Key Metrics', style: Styles.sectionTitleStyle),
                    const SizedBox(height: 8),
                    _buildMetricsGrid(dashboardProvider),
                    const SizedBox(height: 16),
                    Text('Filters', style: Styles.sectionTitleStyle),
                    const SizedBox(height: 8),
                    _buildFilters(dashboardProvider),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Use Row for wide screens, Column for narrow
                        if (constraints.maxWidth > 600) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Chart
                              Expanded(
                                flex: 2,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: ChartWidget(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Profile
                              Expanded(
                                flex: 1,
                                child: ProfileCard(
                                  profile: businessProfile,
                                  onViewProfile: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ProfileModal(profile: businessProfile),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          // On small screens, stack vertically
                          return Column(
                            children: [
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: ChartWidget(),
                                ),
                              ),
                              const SizedBox(height: 18),
                              ProfileCard(
                                profile: businessProfile,
                                onViewProfile: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ProfileModal(profile: businessProfile),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recent Activity', style: Styles.sectionTitleStyle),
                            const SizedBox(height: 8),
                            ActivityList(activities: dashboardProvider.activities),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMetricsGrid(DashboardProvider dashboardProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: dashboardProvider.metrics.length,
      itemBuilder: (context, index) {
        final metric = dashboardProvider.metrics[index];
        return MetricCard(
          title: metric.title,
          value: metric.value,
          icon: metric.icon,
          color: metric.color,
        );
      },
    );
  }

  Widget _buildFilters(DashboardProvider dashboardProvider) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: dashboardProvider.periodFilter,
            decoration: InputDecoration(
              labelText: 'Period',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'day', child: Text('Today')),
              DropdownMenuItem(value: 'week', child: Text('This Week')),
              DropdownMenuItem(value: 'month', child: Text('This Month')),
              DropdownMenuItem(value: 'year', child: Text('This Year')),
            ],
            onChanged: (value) {
              if (value != null) {
                dashboardProvider.setPeriodFilter(value);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: dashboardProvider.sectorFilter,
            decoration: InputDecoration(
              labelText: 'Sector',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: const [
              DropdownMenuItem(value: '', child: Text('All Sectors')),
              DropdownMenuItem(value: '5', child: Text('Clothing')),
            ],
            onChanged: (value) {
              dashboardProvider.setSectorFilter(value ?? '');
            },
          ),
        ),
      ],
    );
  }

  void _showUserMenu(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              userProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() {
    final now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
}
