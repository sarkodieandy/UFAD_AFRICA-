import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/supplier_model.dart';

class SuppliersProvider with ChangeNotifier {
  final _api = ApiService();

  List<Supplier> suppliers = [];
  bool loading = false;
  String? error;

  Future<void> fetchSuppliers() async {
    _setLoading(true);
    try {
      final res = await _api.getSuppliers();
      suppliers = res.map<Supplier>((e) => Supplier.fromJson(e)).toList();
    } catch (e) {
      error = 'Failed to fetch suppliers: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addSupplier(Supplier supplier) async {
    _setLoading(true);
    try {
      await _api.addSupplier(supplier.toJson());
      await fetchSuppliers();
    } catch (e) {
      error = 'Add failed: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    _setLoading(true);
    try {
      await _api.updateSupplier(supplier.id, supplier.toJson());
      await fetchSuppliers();
    } catch (e) {
      error = 'Update failed: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteSupplier(int id) async {
    _setLoading(true);
    try {
      await _api.deleteSupplier(id);
      suppliers.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      error = 'Delete failed: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool val) {
    loading = val;
    notifyListeners();
  }
}
