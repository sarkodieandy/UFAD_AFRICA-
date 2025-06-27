import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  double totalBalance = 32833.33;

  List<Map<String, dynamic>> transactions = [
    {
      "type": "Deposit",
      "account": "Momo",
      "secondaryAccount": "N/A",
      "supplier": "N/A",
      "purchase": "N/A",
      "amount": 500.0,
      "description": "Debt payment for customer ID: 10",
      "date": "2025-06-24 09:05:00",
    },
    // Add more if needed
  ];

  void addTransaction(Map<String, dynamic> transaction) {
    transactions.insert(0, transaction);
    notifyListeners();
  }
}
