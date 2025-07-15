import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../core/constants/colors.dart';
import '../widgets/loader.dart';

class ProductListScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Products - $categoryName'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return FutureBuilder(
            future: provider.fetchProducts(categoryId),
            builder: (context, snapshot) {
              if (provider.loading) return const Loader();
              if (provider.error != null) {
                return Center(child: Text(provider.error!));
              }
              if (provider.products.isEmpty) {
                return const Center(child: Text("No products found."));
              }

              return ListView.builder(
                itemCount: provider.products.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final p = provider.products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('₵${p.price.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(p.categoryName, style: const TextStyle(fontSize: 12)),
                              const Icon(Icons.arrow_forward_ios, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
