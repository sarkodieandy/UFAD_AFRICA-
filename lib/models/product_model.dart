class Product {
  final int id;
  final String name;
  final double price;
  final String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: int.tryParse(json['id'].toString()) ?? 0,
        name: json['name'] ?? '',
        price: double.tryParse(json['price'].toString()) ?? 0.0,
        categoryName: json['category_name'] ?? 'N/A',
      );
}
