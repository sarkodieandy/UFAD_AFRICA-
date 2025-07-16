import 'package:flutter/material.dart';
import '../models/sale_model.dart';
import '../services/api_service.dart';

class SaleProvider extends ChangeNotifier {
  final _api = ApiService();

  List<Sale> sales = [];
  bool loading = false;
  String? error;

  Future<void> fetchSales() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _api.getSales();
      sales = res.map<Sale>((e) => Sale.fromJson(e)).toList();
    } catch (e) {
      error = 'Failed to fetch sales: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

 Future<void> addSale(Map<String, dynamic> data) async {
  _setLoading(true);
  try {
    debugPrint('📤 Adding sale with payload: $data');
    await _api.addSale(data);
    debugPrint('✅ Sale successfully added!');
    await fetchSales(); // Refresh list
  } catch (e, stack) {
    error = 'Add sale failed: $e';
    debugPrint('❌ Add sale failed: $e');
    debugPrint('📛 Stack trace:\n$stack');
    rethrow;
  } finally {
    _setLoading(false);
  }
}

 

  Future<void> updateSale(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _api.updateSale(id, data);
      await fetchSales(); // Refresh list after update
    } catch (e) {
      error = 'Update sale failed: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteSale(int id) async {
    _setLoading(true);
    try {
      await _api.deleteSale(id);
      sales.removeWhere((s) => s.id == id);
    } catch (e) {
      error = 'Delete sale failed: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
