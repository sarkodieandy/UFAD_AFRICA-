import 'package:flutter/material.dart';
import 'package:ufad/suppliers/supplier_model.dart';


class SupplierProvider extends ChangeNotifier {
  final List<Supplier> _suppliers = [
    Supplier(
      name: "Test Supplier",
      type: "Individual",
      business: "",
      category: "Electronics",
      phone: "+233987654321",
      mobile: "",
      location: "",
    ),
    // Add more as needed
  ];

  List<Supplier> get suppliers => _suppliers;

  void addSupplier(Supplier supplier) {
    _suppliers.add(supplier);
    notifyListeners();
  }

  void editSupplier(int index, Supplier supplier) {
    _suppliers[index] = supplier;
    notifyListeners();
  }

  void deleteSupplier(int index) {
    _suppliers.removeAt(index);
    notifyListeners();
  }
}
