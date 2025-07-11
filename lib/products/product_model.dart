import 'package:ufad/products/product_categories.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });
}
