// lib/providers/dashboard_provider.dart
import 'package:flutter/material.dart';
import 'package:ufad/dashboad/model/metric_model.dart';
import 'package:ufad/dashboad/model/transaction_model.dart';
import 'package:ufad/dashboad/widget/activity.dart';

class DashboardProvider with ChangeNotifier {
  String _periodFilter = 'month';
  String _sectorFilter = '';
  List<Metric> _metrics = [];
  List<Transaction> _transactions = [];
  List<Activity> _activities = [];
  bool _isLoading = false;

  String get periodFilter => _periodFilter;
  String get sectorFilter => _sectorFilter;
  List<Metric> get metrics => _metrics;
  List<Transaction> get transactions => _transactions;
  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;

  DashboardProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Initialize metrics - same as your HTML
    _metrics = [
      Metric('Total Expenses', 'GHS 4,800.00', Icons.money, Colors.green),
      Metric('Total Profit', 'GHS 10,500.00', Icons.trending_up, Colors.green),
      Metric('Credit Score', '638 (Bronze)', Icons.star, Colors.green),
      Metric('Total Sales', 'GHS 38,000.00', Icons.shopping_cart, Colors.green),
      Metric('Unpaid Sales', 'GHS 0.00', Icons.warning, Colors.red),
      Metric('Top Debtors', 'N/A', Icons.person_off, Colors.red),
      Metric('Loan Qualification', 'Eligible', Icons.notifications, Colors.green),
    ];

    // EXACT recent activities from your HTML
    _activities = [
      Activity(
        username: 'customer', 
        action: 'login', 
        timestamp: '2025-07-11 11:31:53'
      ),
      Activity(
        username: 'customer', 
        action: 'login', 
        timestamp: '2025-07-11 10:03:12'
      ),
      Activity(
        username: 'customer', 
        action: 'login', 
        timestamp: '2025-07-08 21:21:18'
      ),
      Activity(
        username: 'customer', 
        action: 'login', 
        timestamp: '2025-07-08 20:18:56'
      ),
      Activity(
        username: 'customer', 
        action: 'login', 
        timestamp: '2025-07-08 19:18:12'
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void setPeriodFilter(String period) {
    _periodFilter = period;
    notifyListeners();
  }

  void setSectorFilter(String sector) {
    _sectorFilter = sector;
    notifyListeners();
  }

  Future<void> searchTransactions(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}