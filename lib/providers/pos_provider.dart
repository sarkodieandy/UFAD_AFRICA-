import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class PosProvider with ChangeNotifier {
  final _api = ApiService();
  bool loading = false;

  Future<void> createPOS({
    required int customerId,
    required int accountId,
    required double amount,
    required List<Map<String, dynamic>> items,
  }) async {
    loading = true;
    notifyListeners();

    try {
      await _api.post('/pos', {
        'customer_id': customerId,
        'payment_amount': amount,
        'account_id': accountId,
        'items': items,
      });
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
