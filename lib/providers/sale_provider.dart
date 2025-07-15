import 'package:flutter/material.dart';
import 'package:ufad/services/api_service.dart';

class SaleProvider extends ChangeNotifier {
  final _api = ApiService();

  List<dynamic> sales = [];
  bool loading = false;
  String? error;

  Future<void> fetchSales() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      sales = await _api.getSales();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addSale(Map<String, dynamic> data) async {
    try {
      loading = true;
      notifyListeners();

      await _api.addSale(data);
      await fetchSales();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateSale(int id, Map<String, dynamic> data) async {
    try {
      loading = true;
      notifyListeners();

      await _api.updateSale(id, data);
      await fetchSales();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSale(int id) async {
    try {
      loading = true;
      notifyListeners();

      await _api.deleteSale(id);
      sales.removeWhere((e) => e['id'] == id);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
