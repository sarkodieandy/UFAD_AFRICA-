import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class PaymentProvider with ChangeNotifier {
  final _api = ApiService();
  bool loading = false;

  Future<void> simulatePayment({
    required double amount,
    required String transactionRef,
  }) async {
    loading = true;
    notifyListeners();

    try {
      await _api.post('/payment', {
        'amount': amount,
        'transaction_ref': transactionRef,
      });
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
