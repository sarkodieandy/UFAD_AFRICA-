import 'package:flutter/material.dart';
import '../models/customer.dart';

class CustomerProvider with ChangeNotifier {
  final List<Customer> _customers = [
    Customer(
      name: "SOLOMON",
      accountType: "Individual",
      businessName: "",
      category: "Clothing",
      phone: "0545304660",
      mobile: "0545304660",
      location: "KASOA",
    ),
    // Add more as needed
  ];

  List<Customer> get customers => List.unmodifiable(_customers);

  void addCustomer(Customer c) {
    _customers.add(c);
    notifyListeners();
  }

  void updateCustomer(int index, Customer c) {
    _customers[index] = c;
    notifyListeners();
  }

  void deleteCustomer(int index) {
    _customers.removeAt(index);
    notifyListeners();
  }
}
