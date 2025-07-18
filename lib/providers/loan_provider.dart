// $file — insert actual code here// 📁 lib/providers/loan_provider.dart
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class LoanProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  bool loading = false;

  Future<void> addLoan({
    required int userId,
    required int loanTypeId,
    required double amount,
    required int duration,
  }) async {
    loading = true;
    notifyListeners();

    final payload = {
      'loan_type_id': loanTypeId,
      'amount': amount,
      'duration': duration,
      'user_id': userId,
    };

    try {
      await _api.post('/loans', payload);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
