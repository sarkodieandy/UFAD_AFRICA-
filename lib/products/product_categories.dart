import 'package:flutter/material.dart';

// Category Model
class ProductCategory {
  final int id;
  final String name;
  final IconData icon;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  // Add these for DropdownButtonFormField to match selection!
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// List of All Categories
const List<ProductCategory> allCategories = [
  ProductCategory(id: 1, name: 'Electronics', icon: Icons.devices_other),
  ProductCategory(id: 2, name: 'Food & Beverages', icon: Icons.fastfood),
  ProductCategory(id: 3, name: 'Books', icon: Icons.menu_book),
  ProductCategory(id: 4, name: 'Clothing', icon: Icons.checkroom),
  ProductCategory(id: 5, name: 'Beauty Products', icon: Icons.spa),
  ProductCategory(id: 6, name: 'Furniture', icon: Icons.chair_alt),
  ProductCategory(id: 7, name: 'Jewelry', icon: Icons.diamond),
  ProductCategory(id: 8, name: 'Home Appliances', icon: Icons.kitchen),
  ProductCategory(id: 9, name: 'Sports Equipment', icon: Icons.sports_soccer),
  ProductCategory(id: 10, name: 'Toys & Games', icon: Icons.toys),
  // ... Add more as needed
];
