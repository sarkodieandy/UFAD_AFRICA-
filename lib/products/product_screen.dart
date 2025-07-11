import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/Pos/dialogues/filter_bar.dart';
import 'package:ufad/products/product_card.dart';
import 'package:ufad/products/product_form.dart';
import 'package:ufad/provider/product_provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              FilterBar(),
              const SizedBox(height: 10),
              Expanded(
                child: provider.products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 60, color: Colors.teal.shade100),
                            const SizedBox(height: 10),
                            const Text(
                              "No products found",
                              style: TextStyle(fontSize: 15, color: Colors.teal, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Tap '+' to add your first product",
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: ProductCard(
                              key: ValueKey(product.id),
                              product: product,
                              onEdit: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => AnimatedPadding(
                                  duration: const Duration(milliseconds: 220),
                                  curve: Curves.easeOutBack,
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(ctx).viewInsets.bottom,
                                    left: 12, right: 12, top: 24,
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(16),
                                    clipBehavior: Clip.antiAlias,
                                    child: ProductForm(
                                      initial: product,
                                      onSubmit: (p) => provider.updateProduct(p),
                                    ),
                                  ),
                                ),
                              ),
                              onDelete: () => showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Product', style: TextStyle(fontSize: 15)),
                                  content: Text(
                                    'Are you sure you want to delete "${product.name}"?',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        provider.deleteProduct(product.id);
                                        Navigator.pop(ctx);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Add', style: TextStyle(fontSize: 15)),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 12, right: 12, top: 24,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: ProductForm(
                onSubmit: (p) => provider.addProduct(p),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
