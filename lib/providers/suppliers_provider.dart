import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/supplier_model.dart';

class SuppliersProvider with ChangeNotifier {
  final _api = ApiService();

  List<Supplier> suppliers = [];
  bool loading = false;
  String? error;

  Future<void> fetchSuppliers() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _api.getSuppliers();
      suppliers = res.map<Supplier>((e) => Supplier.fromJson(e)).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addSupplier(Supplier supplier) async {
    try {
      loading = true;
      notifyListeners();

      await _api.addSupplier(supplier.toJson());
      await fetchSuppliers();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    try {
      loading = true;
      notifyListeners();

      await _api.updateSupplier(supplier.id, supplier.toJson());
      await fetchSuppliers();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      loading = true;
      notifyListeners();

      await _api.deleteSupplier(id);
      await fetchSuppliers();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
