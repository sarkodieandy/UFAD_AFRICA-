import 'package:flutter/foundation.dart';
import 'package:ufad/services/register_api.dart';

class LoanProvider with ChangeNotifier {
  List<Map<String, dynamic>> _myLoans = [];
  bool _hasOffers = false;
  double _totalDebt = 0.0;
  double _paid = 0.0;
  double _balance = 0.0;
  String _deadline = 'N/A';
  List<Map<String, dynamic>> _paymentHistory = [];
  bool _isLoading = false;
  String? _error;
  int? _userId; // Set via login

  List<Map<String, dynamic>> get myLoans => _myLoans;
  bool get hasOffers => _hasOffers;
  double get totalDebt => _totalDebt;
  double get paid => _paid;
  double get balance => _balance;
  String get deadline => _deadline;
  List<Map<String, dynamic>> get paymentHistory => _paymentHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = ApiService();

  // Set user ID after login
  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  // Fetch loans and offers
  Future<void> fetchLoans() async {
    if (_userId == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchLoans(userId: _userId!);
      _myLoans = List<Map<String, dynamic>>.from(data['loans'] ?? []);
      _hasOffers = data['has_offers'] ?? false;
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Fetch loans failed: $e');
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  // Apply for a new loan
  Future<void> applyLoan({
    required String product,
    required double amount,
    required String tenure,
  }) async {
    if (_userId == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.applyLoan(
        userId: _userId!,
        product: product,
        amount: amount,
        tenure: tenure,
      );
      _myLoans.add({
        'product': product,
        'amount': amount,
        'tenure': tenure,
        'status': 'Pending',
        'created_at': DateTime.now().toIso8601String(),
        'balance': amount,
        'due_date': 'N/A',
        'loan_id': response['loan_id'],
      });
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Apply loan failed: $e');
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  // Fetch loan repayment stats and history
  Future<void> fetchRepayments() async {
    if (_userId == null) {
      _error = 'No user logged in';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchLoanRepayments(userId: _userId!);
      _totalDebt = data['total_debt']?.toDouble() ?? 0.0;
      _paid = data['paid']?.toDouble() ?? 0.0;
      _balance = data['balance']?.toDouble() ?? 0.0;
      _deadline = data['deadline'] ?? 'N/A';
      _paymentHistory = List<Map<String, dynamic>>.from(data['payment_history'] ?? []);
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Fetch repayments failed: $e');
      }
    }
    _isLoading = false;
    notifyListeners();
  }
}