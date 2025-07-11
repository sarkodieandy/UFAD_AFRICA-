// class Product {
//   final int productId;
//   final int userId;
//   final int businessId;
//   final int categoryId;
//   final String name;
//   final String? description;
//   final double price;
//   final double costPrice;
//   final double sellingPrice;
//   final double profitMargin;

//   Product({
//     required this.productId,
//     required this.userId,
//     required this.businessId,
//     required this.categoryId,
//     required this.name,
//     this.description,
//     required this.price,
//     required this.costPrice,
//     required this.sellingPrice,
//     required this.profitMargin, required category,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     productId: json['product_id'],
//     userId: json['user_id'],
//     businessId: json['business_id'],
//     categoryId: json['category_id'],
//     name: json['name'],
//     description: json['description'],
//     price: (json['price'] as num).toDouble(),
//     costPrice: (json['cost_price'] as num).toDouble(),
//     sellingPrice: (json['selling_price'] as num).toDouble(),
//     profitMargin: (json['profit_margin'] as num).toDouble(), category: null,
//   );
// }
