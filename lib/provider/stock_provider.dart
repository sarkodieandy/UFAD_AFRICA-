import 'package:flutter/material.dart';
import 'package:ufad/stocks/model/category.dart';
import 'package:ufad/stocks/model/product.dart';
import 'package:ufad/stocks/model/purchase.dart';
import 'package:ufad/stocks/model/supplier.dart';

class StockProvider with ChangeNotifier {
  List<Purchase> _purchases = [];
  List<Category> _categories = [];
  List<Product> _products = [];
  List<Supplier> _suppliers = [];

  StockProvider() {
    _loadMockData();
  }

  List<Purchase> get purchases => _purchases;
  List<Category> get categories => _categories;
  List<Product> get products => _products;
  List<Supplier> get suppliers => _suppliers;

  void addPurchase(Purchase purchase) {
    _purchases.insert(0, purchase);
    notifyListeners();
  }

  void editPurchase(Purchase purchase) {
    final idx = _purchases.indexWhere((e) => e.id == purchase.id);
    if (idx != -1) {
      _purchases[idx] = purchase;
      notifyListeners();
    }
  }

  void deletePurchase(int id) {
    _purchases.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void _loadMockData() {
    _categories = [
      Category(id: 4, name: 'Electronics', icon: 'laptop'),
      Category(id: 14, name: 'Automotive Parts', icon: 'car'),
      // ...more categories
    ];
    _suppliers = [
      Supplier(id: 6, name: 'Test Supplier', categoryId: 4),
    ];
    _products = [
      Product(id: 8, name: 'IPHONE', categoryId: 4, costPrice: 2500, sellingPrice: 4000),
      Product(id: 9, name: 'SAMSUNG TABLET', categoryId: 4, costPrice: 5000, sellingPrice: 6000),
    ];
    _purchases = [
      Purchase(
        id: 10,
        product: _products[1],
        supplier: _suppliers[0],
        category: _categories[0],
        unitCost: 5000.0,
        sellingPrice: 6000.0,
        profitMargin: 16.67,
        quantity: 0,
        totalCost: 15000.0,
        paymentStatus: 'Paid',
        date: DateTime(2025, 6, 24, 8, 54, 23),
      ),
      Purchase(
        id: 9,
        product: _products[0],
        supplier: _suppliers[0],
        category: _categories[0],
        unitCost: 3500.0,
        sellingPrice: 4000.0,
        profitMargin: 37.5,
        quantity: 1,
        totalCost: 3500.0,
        paymentStatus: 'Unpaid',
        date: DateTime(2025, 6, 23, 13, 0, 0),
      ),
      Purchase(
        id: 8,
        product: _products[0],
        supplier: _suppliers[0],
        category: _categories[0],
        unitCost: 3000.0,
        sellingPrice: 4000.0,
        profitMargin: 37.5,
        quantity: 1,
        totalCost: 3000.0,
        paymentStatus: 'Paid',
        date: DateTime(2025, 6, 22, 12, 0, 0),
      ),
    ];
  }
}
