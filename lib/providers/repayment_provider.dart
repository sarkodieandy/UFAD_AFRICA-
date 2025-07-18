import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class RepaymentProvider with ChangeNotifier {
  final _api = ApiService();
  bool loading = false;

  Future<void> addRepayment({
    required int loanId,
    required double amount,
  }) async {
    loading = true;
    notifyListeners();

    try {
      await _api.post('/repayments', {'loan_id': loanId, 'amount': amount});
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
