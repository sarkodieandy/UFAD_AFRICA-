import 'package:flutter/material.dart';

// Product Model
class Product {
  final String name;
  final String category;
  final double price;
  final int categoryId;
  final String description;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.categoryId,
    this.description = '',
  });

  Product copyWith({
    String? name,
    String? category,
    double? price,
    int? categoryId,
    String? description,
  }) {
    return Product(
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
    );
  }
}

// Provider
class ProductProvider with ChangeNotifier {
  final List<Product> _allProducts = [
    Product(
      name: 'SAMSUNG TABLET',
      category: 'Electronics',
      price: 5000.0,
      categoryId: 4,
    ),
    Product(
      name: 'IPHONE',
      category: 'Electronics',
      price: 4000.0,
      categoryId: 4,
    ),
    Product(
      name: 'MANGO',
      category: 'Food & Beverages',
      price: 200.0,
      categoryId: 5,
    ),
    Product(
      name: 'APPLE',
      category: 'Food & Beverages',
      price: 300.0,
      categoryId: 5,
    ),
  ];

  int? _selectedCategoryId;
  String _sortBy = 'recent';

  // ----------- THE KEY FIX: -----------
  int? get selectedCategoryId => _selectedCategoryId;
  String get sortBy => _sortBy;

  // This returns the filtered and sorted list every time
  List<Product> get products {
    List<Product> filtered = [..._allProducts];
    if (_selectedCategoryId != null) {
      filtered =
          filtered.where((p) => p.categoryId == _selectedCategoryId).toList();
    }
    if (_sortBy == 'price-asc') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'price-desc') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }
    // 'recent' just means the default (last added is last in list)
    return filtered;
  }

  void filterProducts({int? categoryId, String? sortBy}) {
    _selectedCategoryId = categoryId;
    if (sortBy != null) _sortBy = sortBy;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategoryId = null;
    _sortBy = 'recent';
    notifyListeners();
  }

  void addProduct(Product p) {
    _allProducts.add(p);
    notifyListeners();
  }

  void updateProduct(int index, Product updated) {
    // Find the original item in the full list using the filtered view's index
    Product oldProduct = products[index];
    int actualIndex = _allProducts.indexWhere(
      (element) =>
          element.name == oldProduct.name &&
          element.price == oldProduct.price &&
          element.categoryId == oldProduct.categoryId,
    );
    if (actualIndex != -1) {
      _allProducts[actualIndex] = updated;
      notifyListeners();
    }
  }

  void deleteProduct(int index) {
    Product toRemove = products[index];
    _allProducts.removeWhere(
      (element) =>
          element.name == toRemove.name &&
          element.price == toRemove.price &&
          element.categoryId == toRemove.categoryId,
    );
    notifyListeners();
  }
}
