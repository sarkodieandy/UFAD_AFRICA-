import 'package:flutter/material.dart';
import 'package:ufad/setup_business/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  // Example filter fields
  int? selectedCategory;
  String sortBy = 'recent';

  // Mock: Replace with your API/database fetching logic
  Future<void> fetchProducts() async {
    // Simulate fetch delay
    await Future.delayed(Duration(seconds: 1));
    // You would parse response from your DB/API
    _products = [
      // Add real data here
    ];
    notifyListeners();
  }

  void filterProducts({
    int? category,
    String? sort,
    int? categoryId,
    String? sortBy,
  }) {
    selectedCategory = category;
    if (sort != null) sortBy = sort;
    notifyListeners();
  }

  // Add product
  Future<void> addProduct(Product p) async {
    _products.add(p);
    notifyListeners();
  }

  // Edit product, Delete product, etc...
}
