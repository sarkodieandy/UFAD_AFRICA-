import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/providers/dashboard_provider.dart';
import 'package:ufad/widgets/loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardProvider>(
      context,
      listen: false,
    );

    await authProvider.tryAutoLogin();

    if (!mounted) return;

    if (authProvider.isAuthenticated && authProvider.user != null) {
      final userId = authProvider.user!.id;

      // ✅ Load the dashboard before navigating
      await dashboardProvider.fetchDashboard(userId);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Loader()));
  }
}
