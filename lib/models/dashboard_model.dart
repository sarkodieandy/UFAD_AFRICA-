class DashboardModel {
  final double totalSales;
  final double totalExpenses;
  final double totalProfit;
  final int creditScore;
  final String creditTier;
  final List<SalesTrend> salesTrend;
  final List<TopDebtor> topDebtors;

  DashboardModel({
    required this.totalSales,
    required this.totalExpenses,
    required this.totalProfit,
    required this.creditScore,
    required this.creditTier,
    required this.salesTrend,
    required this.topDebtors,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] ?? {};
    final trend = json['sales_trend'] ?? {};
    final labels = List<String>.from(trend['labels'] ?? []);
    final values = List.from(trend['values'] ?? []);

    return DashboardModel(
      totalSales: _parseCurrency(metrics['total_sales']),
      totalExpenses: _parseCurrency(metrics['total_expenses']),
      totalProfit: _parseCurrency(metrics['total_profit']),
      creditScore: _parseCreditScore(metrics['credit_score']),
      creditTier: _parseCreditTier(metrics['credit_score']),
      salesTrend: List.generate(
        labels.length,
        (i) {
          final value = i < values.length ? values[i] : 0;
          return SalesTrend(month: labels[i], total: _toDouble(value));
        },
      ),
      topDebtors: _parseTopDebtors(metrics['top_debtors']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
    return 0.0;
  }

  static double _parseCurrency(String? input) {
    if (input == null) return 0.0;
    return _toDouble(input.replaceAll(RegExp(r'[^0-9.]'), ''));
  }

  static int _parseCreditScore(String? scoreStr) {
    if (scoreStr == null) return 0;
    final match = RegExp(r'^(\d+)').firstMatch(scoreStr);
    return int.tryParse(match?.group(1) ?? '') ?? 0;
  }

  static String _parseCreditTier(String? scoreStr) {
    if (scoreStr == null) return '';
    final match = RegExp(r'\(Tier ([A-Za-z ]+)\)').firstMatch(scoreStr);
    return match?.group(1) ?? '';
  }

  static List<TopDebtor> _parseTopDebtors(String? debtorStr) {
    if (debtorStr == null || debtorStr.toLowerCase() == 'n/a') return [];
    final matches = RegExp(r'([^,]+?)\s+\(GHS\s+([\d,.]+)\)').allMatches(debtorStr);

    return matches.map((match) {
      return TopDebtor(
        name: match.group(1)?.trim() ?? '',
        amount: _parseCurrency(match.group(2)),
      );
    }).toList();
  }
}

class SalesTrend {
  final String month;
  final double total;

  SalesTrend({required this.month, required this.total});
}

class TopDebtor {
  final String name;
  final double amount;

  TopDebtor({required this.name, required this.amount});
}
