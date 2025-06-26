import 'package:flutter/material.dart';

class POSProvider extends ChangeNotifier {
  double credits = 0.0;

  double totalSales = 38000.0;
  double totalProfit = 10500.0;
  double totalDebtors = 0;
  double totalDebtOwed = 0;
  double debtBalance = 0;

  List<Map<String, dynamic>> sales = [
    {
      "customer": "SOLOMON",
      "total": 18000.0,
      "paid": 18000.0,
      "balance": 0.0,
      "status": "Paid",
      "date": "2025-07-24",
      "progress": 1.0, // 100%
    },
    {
      "customer": "SOLOMON",
      "total": 8000.0,
      "paid": 8000.0,
      "balance": 0.0,
      "status": "Paid",
      "date": "2025-07-23",
      "progress": 1.0,
    },
    {
      "customer": "SOLOMON",
      "total": 4000.0,
      "paid": 4000.0,
      "balance": 0.0,
      "status": "Paid",
      "date": "2025-07-23",
      "progress": 1.0,
    },
    // Add more if needed
  ];
}
