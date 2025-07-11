import 'package:flutter/material.dart';
import 'package:ufad/products/product_categories.dart';
import 'package:ufad/products/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    // Pre-fill with example data
    Product(
      id: 9, name: "SAMSUNG TABLET", description: "", price: 5000.0, category: allCategories[0]
    ),
    Product(
      id: 8, name: "IPHONE", description: "", price: 4000.0, category: allCategories[0]
    ),
    Product(
      id: 7, name: "MANGO", description: "", price: 200.0, category: allCategories[1]
    ),
    Product(
      id: 6, name: "APPLE", description: "", price: 300.0, category: allCategories[1]
    ),
  ];

  int? _categoryFilter;
  String _priceSort = '';
  List<Product> get products {
    var filtered = [..._products];
    if (_categoryFilter != null) {
      filtered = filtered.where((p) => p.category.id == _categoryFilter).toList();
    }
    if (_priceSort == 'asc') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_priceSort == 'desc') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }
    return filtered;
  }

  int? get categoryFilter => _categoryFilter;
  String get priceSort => _priceSort;

  void setCategoryFilter(int? id) {
    _categoryFilter = id;
    notifyListeners();
  }

  void setPriceSort(String sort) {
    _priceSort = sort;
    notifyListeners();
  }

  void clearFilters() {
    _categoryFilter = null;
    _priceSort = '';
    notifyListeners();
  }

  void addProduct(Product p) {
    _products.insert(0, p);
    notifyListeners();
  }

  void updateProduct(Product p) {
    int i = _products.indexWhere((e) => e.id == p.id);
    if (i != -1) {
      _products[i] = p;
      notifyListeners();
    }
  }

  void deleteProduct(int id) {
    _products.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
