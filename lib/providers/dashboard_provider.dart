import 'package:flutter/foundation.dart';
import '../models/dashboard_model.dart';
import '../services/api_service.dart';
import '../core/constants/exception.dart';

class DashboardProvider with ChangeNotifier {
  final _api = ApiService();

  bool loading = false;
  String? error;
  DashboardModel? dashboard;

  List<TopDebtor> get topDebtors => dashboard?.topDebtors ?? [];
  List<SalesTrend> get salesTrend => dashboard?.salesTrend ?? [];

  Map<String, dynamic> get metrics => {
        'total_sales': dashboard?.totalSales ?? 0,
        'total_expenses': dashboard?.totalExpenses ?? 0,
        'total_profit': dashboard?.totalProfit ?? 0,
        'credit_score': dashboard?.creditScore ?? 0,
        'credit_tier': dashboard?.creditTier ?? '',
      };

  Future<void> fetchDashboard(int userId) async {
    if (loading) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      if (kDebugMode) {
        print('📡 Fetching dashboard for user ID: $userId...');
      }
      final result = await _api.fetchDashboard(userId);

      if (kDebugMode) {
        print('📥 Dashboard API response: $result');
      }

      final status = result['status'] as int?;
      final data = result['data'];

      if (status != 200 || data == null) {
        throw ApiException.badRequest(
          result['message'] ?? 'Invalid dashboard response.',
        );
      }

      dashboard = DashboardModel.fromJson(data);
      if (kDebugMode) {
        print('✅ Dashboard parsed: ${dashboard?.totalSales}');
      }
    } on ApiException catch (e) {
      error = e.message;
      if (kDebugMode) {
        print('❌ API Exception: $error');
      }
    } catch (e) {
      error = 'Failed to load dashboard';
      if (kDebugMode) {
        print('❌ General Exception: $e');
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void resetDashboard() {
    if (kDebugMode) {
      print('🔄 Resetting dashboard state...');
    }
    dashboard = null;
    error = null;
    loading = false;
    notifyListeners();
  }
}
