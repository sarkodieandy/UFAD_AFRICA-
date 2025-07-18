class DashboardModel {
  final double totalSales;
  final double totalExpenses;
  final double totalProfit;
  final double unpaidSales;
  final int creditScore;
  final String creditTier;
  final String loanQualification;
  final String businessName;
  final String businessPhone;
  final String businessLocation;
  final List<TopDebtor> topDebtors;
  final List<SalesTrend> salesTrend;

  DashboardModel({
    required this.totalSales,
    required this.totalExpenses,
    required this.totalProfit,
    required this.unpaidSales,
    required this.creditScore,
    required this.creditTier,
    required this.loanQualification,
    required this.businessName,
    required this.businessPhone,
    required this.businessLocation,
    required this.topDebtors,
    required this.salesTrend,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] ?? {};
    final profile = json['business_profile'] ?? {};
    final trendLabels = json['sales_trend']?['labels'] ?? [];
    final trendValues = json['sales_trend']?['values'] ?? [];

    return DashboardModel(
      totalSales: _parseMoney(metrics['total_sales']),
      totalExpenses: _parseMoney(metrics['total_expenses']),
      totalProfit: _parseMoney(metrics['total_profit']),
      unpaidSales: _parseMoney(metrics['unpaid_sales']),
      creditScore: _parseScore(metrics['credit_score']),
      creditTier: _parseTier(metrics['credit_score']),
      loanQualification: metrics['loan_qualification'] ?? '',
      businessName: profile['business_name'] ?? '',
      businessPhone: profile['business_phone'] ?? '',
      businessLocation: profile['business_location'] ?? '',
      topDebtors: _parseDebtors(metrics['top_debtors']),
      salesTrend: List.generate(
        trendLabels.length,
        (i) => SalesTrend(
          month: trendLabels[i],
          total: double.tryParse('${trendValues[i]}') ?? 0.0,
        ),
      ),
    );
  }

  static double _parseMoney(dynamic val) {
    final value = val?.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(value ?? '') ?? 0.0;
  }

  static int _parseScore(dynamic val) {
    if (val == null || val == 'N/A') return 0;
    final score = val.toString().split(' ').first;
    return int.tryParse(score) ?? 0;
  }

  static String _parseTier(dynamic val) {
    if (val == null || val == 'N/A') return '';
    final parts = val.toString().split('Tier ');
    return parts.length > 1 ? 'Tier ${parts[1]}' : '';
  }

  static List<TopDebtor> _parseDebtors(dynamic raw) {
    if (raw == null || raw == 'N/A') return [];
    return raw
        .toString()
        .split('|')
        .map((e) {
          final match = RegExp(
            r'(.+)\s+\(GHS\s*([\d.]+)\)',
          ).firstMatch(e.trim());
          if (match != null) {
            return TopDebtor(
              name: match.group(1)?.trim() ?? '',
              amount: double.tryParse(match.group(2) ?? '') ?? 0.0,
            );
          }
          return null;
        })
        .whereType<TopDebtor>()
        .toList();
  }

  factory DashboardModel.empty() {
    return DashboardModel(
      totalSales: 0.0,
      totalExpenses: 0.0,
      totalProfit: 0.0,
      unpaidSales: 0.0,
      creditScore: 0,
      creditTier: '',
      loanQualification: '',
      businessName: '',
      businessPhone: '',
      businessLocation: '',
      topDebtors: [],
      salesTrend: [],
    );
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
