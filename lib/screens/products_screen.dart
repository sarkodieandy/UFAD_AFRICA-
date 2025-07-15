import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/loader.dart';

class ProductScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const ProductScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products in $categoryName'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: provider.fetchProducts(categoryId),
        builder: (context, snapshot) {
          if (provider.loading) return const Loader();
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }
          if (provider.products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          return ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final p = provider.products[index];
              return ListTile(
                title: Text(p.name),
                subtitle: Text('₵${p.price.toStringAsFixed(2)}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          );
        },
      ),
    );
  }
}
