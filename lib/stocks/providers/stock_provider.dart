import 'package:flutter/material.dart';

class StockProvider extends ChangeNotifier {
  double totalPaid = 30000;
  double totalUnpaid = 3500;
  double balanceToBePaid = 3500;
  double currentStockValue = 11000;

  final List<Map<String, dynamic>> _purchases = [
    {
      "id": 1,
      "product": "SAMSUNG TABLET",
      "supplier": "Test Supplier",
      "category": "Electronics",
      "unitCost": 5000.0,
      "sellingPrice": 6000.0,
      "profitMargin": 16.67,
      "quantity": 0,
      "totalCost": 15000.0,
      "paymentStatus": "Paid",
      "date": "2025-06-24 08:54:23",
    },
    {
      "id": 2,
      "product": "IPHONE",
      "supplier": "Test Supplier",
      "category": "Electronics",
      "unitCost": 3500.0,
      "sellingPrice": 4000.0,
      "profitMargin": 37.5,
      "quantity": 1,
      "totalCost": 3500.0,
      "paymentStatus": "Unpaid",
      "date": "2025-06-23 13:00:00",
    },
    // ... Add more
  ];

  // Expose an unmodifiable view for safety
  List<Map<String, dynamic>> get purchases => List.unmodifiable(_purchases);

  // Add a new purchase
  void addPurchase(Map<String, dynamic> purchase) {
    purchase["id"] = DateTime.now().millisecondsSinceEpoch; // assign unique id
    _purchases.add(purchase);
    notifyListeners();
  }

  // Update purchase by id (safer than by index)
  void updatePurchase(int id, Map<String, dynamic> updatedPurchase) {
    int index = _purchases.indexWhere((item) => item["id"] == id);
    if (index != -1) {
      _purchases[index] = updatedPurchase..["id"] = id; // preserve id
      notifyListeners();
    }
  }

  // Delete by id (safer than by index)
  void deletePurchase(int id) {
    _purchases.removeWhere((item) => item["id"] == id);
    notifyListeners();
  }

  // Example filter by category
  List<Map<String, dynamic>> filterByCategory(String category) {
    if (category == 'all') return purchases;
    return purchases.where((item) => item["category"] == category).toList();
  }

  // Example filter by payment status
  List<Map<String, dynamic>> filterByPaymentStatus(String status) {
    if (status == 'all') return purchases;
    return purchases.where((item) => item["paymentStatus"] == status).toList();
  }
}
