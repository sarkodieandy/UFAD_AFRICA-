import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Transaction> transactions = [];
  bool loading = false;
  String? error;

  Future<void> fetchTransactions() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _api.getTransactions();
      transactions = res.map<Transaction>((e) => Transaction.fromJson(e)).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Map<String, dynamic> data) async {
    try {
      loading = true;
      notifyListeners();

      await _api.addTransaction(data);
      await fetchTransactions();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(int id, Map<String, dynamic> data) async {
    try {
      loading = true;
      notifyListeners();

      await _api.updateTransaction(id, data);
      await fetchTransactions();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      loading = true;
      notifyListeners();

      await _api.deleteTransaction(id);
      await fetchTransactions();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
