// 📁 lib/models/dashboard_model.dart
class DashboardModel {
  final double totalSales;
  final double totalExpenses;
  final double totalProfit;
  final int creditScore;
  final String creditTier;
  final List<TopDebtor> topDebtors;
  final List<SalesTrend> salesTrend;
  final String businessName;

  DashboardModel({
    required this.totalSales,
    required this.totalExpenses,
    required this.totalProfit,
    required this.creditScore,
    required this.creditTier,
    required this.topDebtors,
    required this.salesTrend,
    required this.businessName,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] ?? {};
    final profile = json['business_profile'] ?? {};
    final trend = json['sales_trend'] ?? {};

    return DashboardModel(
      totalSales: _parseAmount(metrics['total_sales']),
      totalExpenses: _parseAmount(metrics['total_expenses']),
      totalProfit: _parseAmount(metrics['total_profit']),
      creditScore: _parseCreditScore(metrics['credit_score']),
      creditTier: _parseCreditTier(metrics['credit_score']),
      topDebtors: _parseTopDebtors(metrics['top_debtors']),
      salesTrend: _parseSalesTrend(trend),
      businessName: profile['business_name'] ?? 'Unknown Business',
    );
  }

  static double _parseAmount(String? value) {
    if (value == null) return 0.0;
    return double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
  }

  static int _parseCreditScore(String? value) {
    if (value == null || value == 'N/A') return 0;
    final score = RegExp(r'^(\d+)').firstMatch(value);
    return score != null ? int.parse(score.group(1)!) : 0;
  }

  static String _parseCreditTier(String? value) {
    if (value == null || value == 'N/A') return 'Unknown';
    final tier = RegExp(r'Tier\s+([A-Z])').firstMatch(value);
    return tier != null ? 'Tier ${tier.group(1)}' : 'Unknown';
  }

  static List<TopDebtor> _parseTopDebtors(String? value) {
    if (value == null || value == 'N/A') return [];

    return value.split('|').map((item) {
      final match = RegExp(r'(.+?) \(GHS ([\d.]+)\)').firstMatch(item.trim());
      if (match != null) {
        return TopDebtor(
          name: match.group(1)!.trim(),
          amount: double.tryParse(match.group(2)!) ?? 0.0,
        );
      } else {
        return TopDebtor(name: item.trim(), amount: 0.0);
      }
    }).toList();
  }

  static List<SalesTrend> _parseSalesTrend(Map<String, dynamic>? trend) {
    final labels = (trend?['labels'] as List?)?.cast<String>() ?? [];
    final values = (trend?['values'] as List?)?.map((v) => v.toDouble()).toList() ?? [];

    final length = (labels.length < values.length) ? labels.length : values.length;

    return List.generate(length, (i) {
      return SalesTrend(month: labels[i], total: values[i]);
    });
  }
}

class TopDebtor {
  final String name;
  final double amount;

  TopDebtor({required this.name, required this.amount});
}

class SalesTrend {
  final String month;
  final double total;

  SalesTrend({required this.month, required this.total});
}
