import 'product.dart';
import 'supplier.dart';
import 'category.dart';

class Purchase {
  final int id;
  final Product product;
  final Supplier supplier;
  final Category category;
  final double unitCost;
  final double sellingPrice;
  final double profitMargin;
  final int quantity;
  final double totalCost;
  final String paymentStatus;
  final DateTime date;

  Purchase({
    required this.id,
    required this.product,
    required this.supplier,
    required this.category,
    required this.unitCost,
    required this.sellingPrice,
    required this.profitMargin,
    required this.quantity,
    required this.totalCost,
    required this.paymentStatus,
    required this.date,
  });
}
