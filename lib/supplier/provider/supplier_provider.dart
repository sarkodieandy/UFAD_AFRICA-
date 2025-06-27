import 'package:flutter/material.dart';
import '../models/supplier.dart';

class SupplierProvider extends ChangeNotifier {
  final List<Supplier> _suppliers = [
    Supplier(
      name: "Test Supplier",
      accountType: "Individual",
      businessName: "N/A",
      category: "Electronics",
      phone: "0550000000",
      mobile: "0550000000",
      location: "Accra",
    ),
  ];

  List<Supplier> get suppliers => _suppliers;

  void addSupplier(Supplier supplier) {
    _suppliers.add(supplier);
    notifyListeners();
  }

  void deleteSupplier(int index) {
    _suppliers.removeAt(index);
    notifyListeners();
  }
}
