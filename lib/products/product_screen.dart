import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/products/provider/product_provider.dart';
import 'package:ufad/products/widgets/add_product.dart';
import 'package:ufad/products/widgets/product_filters.dart';
import 'package:ufad/products/widgets/product_table.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // You can tune maxWidth as you want (e.g., 700, 900)
    const double maxWidth = 800;

    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: null,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF21C087)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
        ),

        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Consumer<ProductProvider>(
                      builder: (context, provider, _) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Products',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add Product'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF21C087),
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed:
                                        () => showDialog(
                                          context: context,
                                          builder:
                                              (_) => const AddProductDialog(),
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ProductFilters(provider: provider),
                              const SizedBox(height: 12),
                              // Card for the table with scrolling
                              Container(
                                constraints: BoxConstraints(
                                  // minHeight: 320,
                                  maxHeight:
                                      420, // Makes table scroll if many products
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Material(
                                    color: Colors.white,
                                    child: ProductTable(provider: provider),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
