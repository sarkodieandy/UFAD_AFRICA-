import 'package:flutter/foundation.dart';
import 'package:ufad/models/supplier_model.dart';
import 'package:ufad/services/api_service.dart';

class SupplierProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Supplier> _suppliers = [];
  bool loading = false;
  String? error;

  List<Supplier> get suppliers => _suppliers;

  Future<void> fetchSuppliers() async {
    loading = true;
    notifyListeners();

    try {
      final data = await _api.getSuppliers();
      _suppliers = data.map((e) => Supplier.fromJson(e)).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addSupplier(Supplier supplier) async {
    try {
      await _api.addSupplier(supplier.toJson());
      await fetchSuppliers();
    } catch (e) {
      throw Exception('Failed to add supplier: $e');
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      await _api.deleteSupplier(id);
      _suppliers.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete supplier: $e');
    }
  }

  /// ✅ Corrected: Update existing supplier
  Future<void> updateSupplier(Supplier supplier) async {
    try {
      await _api.updateSupplier(supplier.id, supplier.toJson());
      await fetchSuppliers(); // refresh list
    } catch (e) {
      throw Exception('Failed to update supplier: $e');
    }
  }
}
