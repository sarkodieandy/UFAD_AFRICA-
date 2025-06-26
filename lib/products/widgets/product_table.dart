import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/products/provider/product_provider.dart';
import 'package:ufad/products/widgets/delete_product.dart';
import 'package:ufad/products/widgets/edit_product.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({super.key, required ProductProvider provider});

  String _formatPrice(double price) {
    // Comma formatting for thousands
    return price
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.products;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F6F9)),
        columns: const [
          DataColumn(
            label: Text('Icon', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          DataColumn(
            label: Text('Name', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          DataColumn(
            label: Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataColumn(
            label: Text(
              'Price (GHS)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataColumn(
            label: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
        rows: List<DataRow>.generate(products.length, (i) {
          final p = products[i];
          return DataRow(
            cells: [
              DataCell(
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(
                    p.categoryId == 4 ? Icons.computer : Icons.restaurant,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              DataCell(
                Text(
                  p.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(Text(p.category)),
              DataCell(Text(_formatPrice(p.price))),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF21C087),
                        size: 20,
                      ),
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder:
                                (_) => EditProductDialog(index: i, product: p),
                          ),
                      splashRadius: 18,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder:
                                (_) =>
                                    DeleteProductDialog(index: i, product: p),
                          ),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
