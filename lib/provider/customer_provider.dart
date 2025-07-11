import 'package:flutter/material.dart';
import 'package:ufad/customers/model.dart';


class CustomerProvider extends ChangeNotifier {
  final List<Customer> _customers = [
    Customer(
      id: 10,
      accountType: "individual",
      name: "SOLOMON",
      businessName: "",
      category: "Clothing",
      phone: "0545304660",
      mobile: "0545304660",
      location: "KASOA",
      categoryIcon: "fa-tshirt",
    ),
    // More sample data...
  ];

  List<Customer> get customers => _customers;

  void addCustomer(Customer customer) {
    _customers.add(customer);
    notifyListeners();
  }

  void editCustomer(Customer customer) {
    final idx = _customers.indexWhere((c) => c.id == customer.id);
    if (idx != -1) {
      _customers[idx] = customer;
      notifyListeners();
    }
  }

  void deleteCustomer(int id) {
    _customers.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // Filtering logic etc...
}
