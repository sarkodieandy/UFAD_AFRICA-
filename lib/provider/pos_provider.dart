import 'package:flutter/material.dart';
import 'package:ufad/Pos/models/pos_sale.dart';

class PosProvider extends ChangeNotifier {
  // Internal sales list
  final List<PosSale> _sales = [
    PosSale(
      customer: "SOLOMON",
      total: 3991.00,
      paid: 2000.00,
      balance: 1991.00,
      status: "Partially_paid",
      dueDate: DateTime(2025, 7, 26),
      percent: 50.11,
    ),
    PosSale(
      customer: "SARKODIE",
      total: 18000.00,
      paid: 18000.00,
      balance: 0.0,
      status: "Paid",
      dueDate: DateTime(2025, 7, 24),
      percent: 100.0,
    ),
    PosSale(
      customer: "ANTHONY",
      total: 8000.00,
      paid: 8000.00,
      balance: 0.0,
      status: "Paid",
      dueDate: DateTime(2025, 7, 23),
      percent: 100.0,
    ),
  ];

  // Expose an unmodifiable view for safety
  List<PosSale> get sales => List.unmodifiable(_sales);

  // Metrics getters for dashboard
  double get totalSales => _sales.fold(0.0, (sum, sale) => sum + sale.total);
  double get totalPaid  => _sales.fold(0.0, (sum, sale) => sum + sale.paid);
  double get totalBalance => _sales.fold(0.0, (sum, sale) => sum + sale.balance);
  int get totalDebtors => _sales.where((s) => s.balance > 0).length;

  // List all unique customer names
  List<String> get customers => _sales.map((s) => s.customer).toSet().toList();

  // List of accounts (dummy data)
  List<Map<String, dynamic>> get accounts => [
        {
          'name': 'Momo',
          'type': 'Mobile Money',
          'balance': 24333.33,
        },
        {
          'name': 'TERLO SERVICES- GCB',
          'type': 'Bank',
          'balance': 8000.00,
        },
      ];

  // Add Sale
  void addSale(PosSale sale) {
    _sales.insert(0, sale);
    notifyListeners();
  }

  // Remove a sale by index
  void deleteSale(int index) {
    if (index >= 0 && index < _sales.length) {
      _sales.removeAt(index);
      notifyListeners();
    }
  }

  // Update a sale by index
  void updateSale(int index, PosSale newSale) {
    if (index >= 0 && index < _sales.length) {
      _sales[index] = newSale;
      notifyListeners();
    }
  }

  // Pay Debt
  void payDebt({required String customer, required double amount}) {
    // Find first unpaid or partially paid sale for this customer
    final sale = _sales.firstWhere(
      (s) => s.customer == customer && s.balance > 0,
      orElse: () => throw Exception("No outstanding debt for $customer"),
    );
    sale.paid += amount;
    sale.balance = (sale.total - sale.paid).clamp(0, sale.total).toDouble();
    if (sale.balance == 0) {
      sale.status = "Paid";
      sale.percent = 100.0;
    } else if (sale.paid == 0) {
      sale.status = "Unpaid";
      sale.percent = 0.0;
    } else {
      sale.status = "Partially_paid";
      sale.percent = ((sale.paid / sale.total) * 100).clamp(0, 100);
    }
    notifyListeners();
  }
}
